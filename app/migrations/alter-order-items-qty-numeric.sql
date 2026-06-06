-- qty pada CSV dapat berisi desimal (mis. 1.5 KG)
ALTER TABLE order_items
ALTER COLUMN qty TYPE NUMERIC USING qty::NUMERIC;
