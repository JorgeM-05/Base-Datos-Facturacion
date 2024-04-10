-- CREATE TABLES
-- CUENTAS - AUTENTICACION
-- compañia
CREATE TABLE company (
    cmp_id INT PRIMARY KEY AUTO_INCREMENT,
    cmp_name VARCHAR(255) NOT NULL,
    cmp_nit VARCHAR(20) NOT NULL,
    cmp_phone VARCHAR(15),
    cmp_address VARCHAR(255),
    cmp_create_at TIMESTAMP,
    cmp_update_at TIMESTAMP
);

-- localizacion
CREATE TABLE location (
    ltn_id INT PRIMARY KEY AUTO_INCREMENT,
    ltn_department VARCHAR(100) NOT NULL,
    ltn_city VARCHAR(255) NOT NULL,
    ltn_create_at TIMESTAMP,
    ltn_update_at TIMESTAMP
);

-- sucursales
CREATE TABLE branch (
    brn_id INT PRIMARY KEY AUTO_INCREMENT,
    cmp_id INT NOT NULL,
    ltn_id INT,
    brn_name VARCHAR(255) NOT NULL,
    brn_address VARCHAR(255),
    brn_phone VARCHAR(15),
    brn_create_at TIMESTAMP,
    brn_update_at TIMESTAMP,
    FOREIGN KEY (cmp_id) REFERENCES company(cmp_id),
    FOREIGN KEY (ltn_id) REFERENCES location(ltn_id)
);

-- configuracion de cuerpo notificaciones 
CREATE TABLE setup_branch (
    stp_id INT PRIMARY KEY AUTO_INCREMENT,
    brn_id INT NOT NULL,
    stp_header_mail varchar(500) NOT NULL,
    stp_body_mail varchar(2000) NOT NULL,
    stp_footer_mail varchar(500) NOT NULL,
    stp_subject_mail varchar(200) NOT NULL,
    FOREIGN KEY (brn_id) REFERENCES branch(brn_id)
);

-- roles
CREATE TABLE customers_role (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) UNIQUE,
    role_description VARCHAR(150)
);

CREATE TABLE users (
    usr_id INT PRIMARY KEY AUTO_INCREMENT,
    usr_email varchar(80) NOT NULL,
    usr_password varchar(255) NOT NULL,
    usr_create_at TIMESTAMP,
    usr_update_at TIMESTAMP
);

-- Socio
CREATE TABLE customers (
    ctm_id INT PRIMARY KEY AUTO_INCREMENT,
    brn_id INT NOT NULL,
    role_id INT NOT NULL,
    usr_id INT NOT NULL,
    ctm_name varchar(80) NOT NULL,
    ctm_last_name varchar(80) NOT NULL,
    ctm_phone varchar(15),
    ctm_card_id varchar(255) NOT NULL,
    ctm_create_at TIMESTAMP,
    ctm_update_at TIMESTAMP,
    FOREIGN KEY (role_id) REFERENCES customers_role(role_id),
    FOREIGN KEY (usr_id) REFERENCES users(usr_id),
    FOREIGN KEY (brn_id) REFERENCES branch(brn_id)
);

-- FACTURACION
-- clientes finales
CREATE TABLE client(
    ctn_id INT PRIMARY KEY AUTO_INCREMENT,
    brn_id INT NOT NULL,
    ctn_type_document VARCHAR(50),
    ctn_document_number VARCHAR(20),
    ctn_first_name VARCHAR(255),
    ctn_last_name VARCHAR(100),
    ctn_address VARCHAR(255),
    ctn_phone VARCHAR(15),
    ctn_email VARCHAR(255),
    ctn_client_type VARCHAR(50),
    ctn_total_amount DECIMAL(10, 2),
    ctn_create_at TIMESTAMP,
    ctn_update_at TIMESTAMP,
    FOREIGN KEY (brn_id) REFERENCES branch(brn_id)
);

-- estados para metodo de pago
CREATE TABLE payment_method(
    pay_id INT PRIMARY KEY,
    pay_name VARCHAR(50) UNIQUE,
    pay_create_at TIMESTAMP,
    pay_update_at TIMESTAMP
);

INSERT INTO
    payment_method(pay_id, pay_name, pay_create_at, pay_update_at)
VALUES
    (1, 'EFECTIVO', NULL, NULL),
    (2, 'TC MASTERCARD', NULL, NULL),
    (3, 'TC VISA', NULL, NULL),
    (4, 'CC MASTERCARD', NULL, NULL),
    (5, 'CC VISA', NULL, NULL),
    (6, 'TC AMEX', NULL, NULL);

-- estados para la factura
CREATE TABLE invoice_status (
    istu_id INT PRIMARY KEY,
    istu_name VARCHAR(50) UNIQUE,
    istu_create_at TIMESTAMP,
    istu_update_at TIMESTAMP
);

INSERT INTO
    invoice_status (
        istu_id,
        istu_name,
        istu_create_at,
        istu_update_at
    )
VALUES
    (1, 'REGISTRADO', null, null),
    -- se regstro en la BD
    (2, 'PENDING', null, null),
    -- se agrega a la cola
    (3, 'ENVIADO', null, null),
    -- se envio el correo
    (4, 'SEND_FAIL', null, null),
    -- error tecnico en el sistema de notificaciones
    (5, 'ERROR_EMAIL', null, null);

-- error en la direccion correo electronico
-- facturacion
CREATE TABLE invoice(
    inv_id INT PRIMARY KEY AUTO_INCREMENT,
    ctn_id INT NOT NULL,
    istu_id INT NOT NULL,
    inv_invoce_number VARCHAR(100),
    inv_date DATE,
    inv_type VARCHAR(50),
    inv_delivery_type VARCHAR(50),
    inv_payment_method VARCHAR(50),
    inv_gross_total DECIMAL(50, 2),
    inv_discounts DECIMAL(50, 2),
    inv_subtotal DECIMAL(50, 2),
    inv_total_vat DECIMAL(50, 2),
    inv_total DECIMAL(50, 2),
    inv_observation VARCHAR(200),
    inv_employee_id varchar(50),
    FOREIGN KEY (ctn_id) REFERENCES client(ctn_id),
    FOREIGN KEY (istu_id) REFERENCES invoice_status(istu_id)
);

-- proveedor
-- Category
CREATE TABLE category (
    ctg_id INT PRIMARY KEY AUTO_INCREMENT,
    ctg_name VARCHAR(255) NOT NULL,
    ctg_description VARCHAR(255),
    cmp_id INT NOT NULL
);

-- impuestos
CREATE TABLE tax (
    tax_id INT PRIMARY KEY AUTO_INCREMENT,
    tax_name VARCHAR(255),
    tax_description VARCHAR(255),
    tax_percentage DECIMAL(5, 2),
    tax_type VARCHAR(50)
);

-- descuentos
CREATE TABLE discount (
    dct_id INT PRIMARY KEY AUTO_INCREMENT,
    dct_name VARCHAR(255) NOT NULL,
    dct_description VARCHAR(255),
    dct_type VARCHAR(50),
    dct_percentage DECIMAL(5, 2)
);

-- proveedores
CREATE TABLE supplier (
    spl_id INT PRIMARY KEY AUTO_INCREMENT,
    spl_name VARCHAR(255),
    spl_nit VARCHAR(20),
    spl_address VARCHAR(255),
    spl_contact_person VARCHAR(100),
    spl_phone VARCHAR(15),
    spl_email VARCHAR(255)
);

-- productos
CREATE TABLE product (
    prd_id INT PRIMARY KEY AUTO_INCREMENT,
    spl_id INT NULL,
    brn_id INT NOT NULL,
    ctg_id INT,
    dct_id INT,
    tax_id INT NOT NULL,
    prd_name VARCHAR(255),
    prd_description TEXT,
    prd_status VARCHAR(50),
    prd_barcode VARCHAR(50),
    prd_reference VARCHAR(50),
    prd_location VARCHAR(255) NULL,
    prd_unit_price DECIMAL(10, 2),
    prd_selling_price DECIMAL(10, 2),
    prd_state BOOLEAN,
    prd_stock_quantity INT NOT NULL,
    FOREIGN KEY (ctg_id) REFERENCES category(ctg_id),
    FOREIGN KEY (spl_id) REFERENCES supplier(spl_id),
    FOREIGN KEY (brn_id) REFERENCES branch(brn_id),
    FOREIGN KEY (dct_id) REFERENCES discount(dct_id),
    FOREIGN KEY (tax_id) REFERENCES tax(tax_id)
);

-- Historial de productos
CREATE TABLE product_History (
    prdH_id INT AUTO_INCREMENT PRIMARY KEY,
    prd_id INT,
    prdH_transaction_id VARCHAR(200),
    prdH_transaction_date TIMESTAMP,
    prdH_event_Type VARCHAR(50),
    prdH_previous_quantity INT,
    prdH_current_quantity INT,
    prdH_reason TEXT,
    -- employe VARCHAR(100), -- por definir fk
    FOREIGN KEY (prd_id) REFERENCES product(prd_id)
);

-- detalle factura
CREATE TABLE details_invoce(
    dtl_id INT PRIMARY KEY AUTO_INCREMENT,
    inv_id INT NOT NULL,
    prd_id INT NOT NULL,
    dtl_code VARCHAR(200),
    dtl_name_product VARCHAR(50),
    dtl_category VARCHAR(50),
    dtl_description VARCHAR(200),
    dtl_quantity INT,
    dtl_unit_price DECIMAL(20, 2),
    dtl_percentage_discount DECIMAL(20, 2),
    dtl_value_discount DECIMAL(20, 2),
    dtl_tax DECIMAL(20, 2),
    dtl_value_tax DECIMAL(20, 2),
    dtl_sub_total DECIMAL(20, 2),
    dtl_total DECIMAL(20, 2),
    FOREIGN KEY (inv_id) REFERENCES invoice(inv_id),
    FOREIGN KEY (prd_id) REFERENCES product(prd_id)
);

-- factura electronica
CREATE TABLE electronic_invoice (
    eleci_id INT PRIMARY KEY AUTO_INCREMENT,
    istu_id INT,
    ctn_id int NOT NULL,
    brn_id int NOT NULL,
    eleci_invoce_number VARCHAR(100) NOT NULL,
    eleci_response_code VARCHAR(50),
    eleci_details_code VARCHAR(100),
    eleci_create_at TIMESTAMP,
    eleci_update_at TIMESTAMP,

    FOREIGN KEY (istu_id) REFERENCES invoice_status(istu_id)
);

-- historial de facturacion electronica
-- POR DEFINIR
/*CREATE TABLE invoice_status_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    inv_id INT,
    old_status VARCHAR(50),
    new_status VARCHAR(50),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (inv_id) REFERENCES invoice(inv_id)
);
*/

