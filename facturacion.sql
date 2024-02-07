-- compañia
CREATE TABLE company (
    company_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    nit VARCHAR(20) NOT NULL,
    phone VARCHAR(15),
    address VARCHAR(255)
);
-- localizacion
CREATE TABLE location (
    location_id INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(100) NOT NULL,
    city VARCHAR(255) NOT NULL
);

-- sucursales
CREATE TABLE branch (
    branch_id INT PRIMARY KEY AUTO_INCREMENT,
    company_id INT NOT NULL,
    location_id INT ,
    name VARCHAR(255) NOT NULL,
    address VARCHAR(255),
    phone VARCHAR(15),
    FOREIGN KEY (company_id) REFERENCES company(company_id),
    FOREIGN KEY (location_id) REFERENCES location(location_id)
);

-- roles
CREATE TABLE employee_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE,
    description TEXT
);

-- empleados
CREATE TABLE employee (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    last_name VARCHAR(100),
    id_card VARCHAR(20),
    username VARCHAR(50) NOT NULL,
    password VARCHAR(255) NOT NULL,
    role_id INT,
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),
    FOREIGN KEY (role_id) REFERENCES employee_role(role_id)
);


-- clientes
CREATE TABLE client (
    client_id INT PRIMARY KEY AUTO_INCREMENT,
    branch_id INT,
    type_document VARCHAR(50),
    document_number VARCHAR(20),
    first_name VARCHAR(255),
    last_name VARCHAR(100),
    address VARCHAR(255),
    phone VARCHAR(15),
    email VARCHAR(255),
    client_type VARCHAR(50),
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);

-- estados para metodo de pago
CREATE TABLE payment_method(
	id INT PRIMARY KEY,
	name VARCHAR(50) UNIQUE
);

INSERT INTO payment_method(id,name)
VALUES (1,'EFECTIVO'),(2,'TC MASTERCARD'),(3,'TC VISA'),(4,'CC MASTERCARD'),(5,'CC VISA'),(6,'TC AMEX')


-- estados para la factura
CREATE TABLE invoice_status (
    status_id INT PRIMARY KEY,
    state_name VARCHAR(50) UNIQUE
);

INSERT INTO invoice_status (status_id,state_name) 
VALUES (1,'CREADO'),(2,'ENVIADO'),(3,'REENVIADO'),(4,'CANCELADO');


-- facturacion
CREATE TABLE invoice (
    invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    client_id INT,
    invoce_number VARCHAR(100),
    date DATE,
    type VARCHAR(50),
    status_id INT NOT NULL,
    delivery_type VARCHAR(50),
    payment_method VARCHAR(50),
    gross_total DECIMAL(20, 2),
    discounts DECIMAL(20, 2),
    subtotal DECIMAL(20, 2),
    total_vat DECIMAL(20, 2),
    total DECIMAL(20, 2),
    observation VARCHAR(200),
    employee_id varchar(50),
    
    FOREIGN KEY (client_id) REFERENCES client(client_id),
    FOREIGN KEY (status_id) REFERENCES invoice_status(status_id)
);


CREATE TABLE details_invoce(
	invoce_detail_id INT PRIMARY KEY AUTO_INCREMENT,
	invoice_id INT NOT NULL,
	product_id INT,
	code VARCHAR(200),
	name_product VARCHAR(50),
	category VARCHAR(50),
	description VARCHAR(200),
	quantity INT,
	unit_price DECIMAL(20, 2),
	percentage_discount DECIMAL(20, 2),
	value_discount DECIMAL(20, 2),
	tax DECIMAL(20, 2),
	value_tax DECIMAL(20, 2),
	sub_total DECIMAL(20, 2),
	total DECIMAL(20, 2),
	
	FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
	FOREIGN KEY (product_id) REFERENCES product(product_id)
);



-- proveedor
CREATE TABLE supplier (
    supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    nit VARCHAR(20),
    address VARCHAR(255),
    contact_person VARCHAR(100),
    phone VARCHAR(15),
    email VARCHAR(255)
);
CREATE TABLE category (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    description TEXT
);




-- impuestos
CREATE TABLE tax (
    tax_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    description TEXT,
    percentage DECIMAL(5, 2),
    type VARCHAR(50)
);

-- descuentos
CREATE TABLE discount (
    discount_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    description TEXT,
    type VARCHAR(50),
    percentage DECIMAL(5, 2)
);

-- productos
CREATE TABLE product (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255),
    description TEXT,
    product_status VARCHAR(50),
    barcode VARCHAR(50),
    reference VARCHAR(50),
    location VARCHAR(255) NULL,
    unit_price DECIMAL(10, 2),
    selling_price DECIMAL(10, 2),
    state BOOLEAN,
    
    supplier_id INT NULL,
    branch_id INT NOT NULL,
    category_id INT,
    discount_id INT, 
    tax_id INT,  
    
    FOREIGN KEY (category_id) REFERENCES category(category_id),
    FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id),
    FOREIGN KEY (branch_id) REFERENCES branch(branch_id),    
    FOREIGN KEY (discount_id) REFERENCES discount(discount_id), -- Clave foránea para el descuento
    FOREIGN KEY (tax_id) REFERENCES tax(tax_id)   
    
);

-- inventario
-- pendiente por definir la estructura
CREATE TABLE inventory (
    inventory_id INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    supplier_id INT,
    quantity INT,
    last_purchase_date DATE,
    last_sale_date DATE,
    total_purchases INT,
    total_sales INT,
    
    FOREIGN KEY (product_id) REFERENCES product(product_id)
    -- FOREIGN KEY (supplier_id) REFERENCES supplier(supplier_id)
);



-- factura electronica
CREATE TABLE electronic_invoice (
    electronic_invoice_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    status_id INT,
    authorization_code VARCHAR(50),
    authorization_date DATE,
    
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id),
    FOREIGN KEY (status_id) REFERENCES invoice_status(status_id)
);

-- historial de facturacion electronica
CREATE TABLE invoice_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    invoice_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    -- Puedes agregar más columnas según tus necesidades
    FOREIGN KEY (invoice_id) REFERENCES invoice(invoice_id)
);


