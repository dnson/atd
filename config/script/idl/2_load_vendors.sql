
-- Trim values of vendormaster
UPDATE VendorMaster SET Vendor_Code = upper(trim(Vendor_Code)), Vendor_Name = upper(trim(Vendor_Name)),
Vendor_GLN = trim(Vendor_GLN), Submit_Type = trim(Submit_Type), Vendor_Address1 = trim(Vendor_Address1),
Vendor_Address2 = trim(Vendor_Address2), Vendor_Address3 = trim(Vendor_Address3), City = trim(City),
State = trim(State), ZIP_Code = trim(ZIP_Code), Country_Code = trim(Country_Code), Country_Name = trim(Country_Name), 
Contact = trim(Contact), Phone = trim(Phone), Fax = trim(Fax), Email = trim(Email);

-- Check validation errors <> ''
--SELECT * from vendormaster where validation_errors <> '';

-- Insert vendor from PMM with vendor_code not in MSSS
DELETE FROM client_vendors;
ALTER SEQUENCE client_vendors_id_seq RESTART WITH 1;

INSERT INTO client_vendors(vendor_name, vendor_code, created_at, updated_at)
SELECT vendor_name, vendor_code, now(), now() FROM VendorMaster vm;

-- Update remain information for MSSS based on vendor_code from PMM 
UPDATE client_vendors SET vendor_name = vm.vendor_name, address1 = vm.vendor_address1, address2 = vm.vendor_address2, address3 = vm.vendor_address3, city_name = vm.city, state_name = vm.state, zip_code = vm.zip_code, contact_name = vm.contact, phone_number = vm.phone, fax = vm.fax, email = vm.email, updated_at = now(), gln = vm.vendor_gln, country_code = vm.country_code, country_name = c.name, country_id = c.id
FROM VendorMaster vm LEFT JOIN countries c ON vm.country_code = c.code
WHERE client_vendors.vendor_code = vm.vendor_code AND client_vendors.vendor_name = vm.vendor_name;

-- Insert data into sync_vendor_infos table
DELETE FROM sync_vendor_infos;

INSERT INTO sync_vendor_infos(client_vendor_id, recommended_name, created_at, updated_at)
SELECT id, ''::varchar, now(), now()
FROM client_vendors
WHERE id NOT IN (SELECT client_vendor_id FROM sync_vendor_infos);

--- Build search
UPDATE client_vendors SET search_array = client_vendors_search_tokens(id);
UPDATE client_vendors SET search_vector = relevance_tsvector(search_array);

-- Insert contry data from vendor. Should check first
INSERT INTO countries(code, name, is_iso)
SELECT DISTINCT Country_Code, Country_Name, true
FROM vendormaster vm
WHERE NOT EXISTS (SELECT 1 FROM countries c WHERE vm.country_code = c.code AND vm.country_name = c.name)
AND vm.country_code != '';

UPDATE client_vendors SET country_id = c.id
FROM countries c
WHERE client_vendors.country_code = c.code;
select * from client_vendors;