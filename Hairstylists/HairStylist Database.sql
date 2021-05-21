CREATE SCHEMA LAB_REDUNDANCY_HAIR_SALON;
SET SCHEMA LAB_REDUNDANCY_HAIR_SALON;
DROP TABLE stylist_services;DROP TABLE services;DROP TABLE appointments;DROP TABLE stylists;DROP TABLE customers;

CREATE TABLE customers (
last_name          VARCHAR(50),
first_name         VARCHAR(50),
phone_num              VARCHAR(16)         NOT NULL,
CONSTRAINT                  customers_PK      PRIMARY KEY (phone_num)
);
CREATE TABLE stylists(
last_name           VARCHAR(50),
first_name          VARCHAR(50),
phone_num               VARCHAR(16)         NOT NULL,
CONSTRAINT                  stylist_PK      PRIMARY KEY
                            (phone_num )
);
CREATE TABLE appointments (
appointment_date            DATE                NOT NULL,
appointment_time            TIME                NOT NULL,
customer_phone              VARCHAR(16)         NOT NULL,
stylist_phone               VARCHAR(16)         NOT NULL,
CONSTRAINT                  appointment_PK      PRIMARY KEY (appointment_date, appointment_time),
CONSTRAINT                  appointment_FK1     FOREIGN KEY (customer_phone) REFERENCES customers (phone_num),
CONSTRAINT                  appointment_FK2     FOREIGN KEY (stylist_phone) REFERENCES stylists (phone_num)
);

CREATE TABLE services(
name                VARCHAR(30)         NOT NULL,
cost                FLOAT,
duration            TIME,
CONSTRAINT                  service_PK      PRIMARY KEY
                            (name )
);


CREATE TABLE stylist_services (
service_name                VARCHAR(30)         NOT NULL,
stylist_phone              VARCHAR(16)         NOT NULL,
CONSTRAINT                  stylist_services_PK      PRIMARY KEY (service_name, stylist_phone),
CONSTRAINT                  stylist_services_FK1     FOREIGN KEY (stylist_phone) REFERENCES stylists (phone_num),
CONSTRAINT                  stylist_services_FK2     FOREIGN KEY (service_name) REFERENCES services (name)
);

INSERT INTO customers (last_name, first_name, phone_num)
VALUES
('Stark', 'Tony', '555-100-0007'),
('Banner', 'David', '439-200-0101'),
('Rogers', 'Steve', '232-420-9985'),
('Panther', 'Black', '714-982-8696');

INSERT INTO stylists (last_name,first_name,phone_num)
VALUES
( 'Piggy', 'Miss', '714-982-1022'),
( 'The Frog', 'Kermit', '213-593-8989'),
( 'Bear', 'Fozzy', '999-105-4232'),
( 'Piggy', 'Miss', '714-892-2210');

INSERT INTO appointments (appointment_date, appointment_time, customer_phone, stylist_phone)
VALUES
('2021-05-23', '14:00:00', '555-100-0007', '714-982-1022'),
('2021-06-21', '8:00:00', '439-200-0101', '213-593-8989'),
('2021-05-01', '13:00', '232-420-9985', '999-105-4232'),
('2021-07-06', '9:00:00', '714-982-8696', '714-892-2210');

INSERT INTO services (name,cost,duration)
VALUES
( 'hair tipping', 40.00, '0:45'),
( 'skin recoloring', 125.57, '2:15'),
( 'butch haircut', 15, '0:15'),
( 'pedicure', 23.95, '1:15');

INSERT INTO stylist_services
 (service_name, stylist_phone)
VALUES
( 'hair tipping', '714-982-1022'),
( 'skin recoloring', '213-593-8989'),
( 'butch haircut', '999-105-4232'),
( 'pedicure', '714-892-2210');



SELECT *
FROM appointments
INNER JOIN customers on appointments.customer_phone = customers.phone_num
INNER JOIN stylists on appointments.stylist_phone = stylists.phone_num
INNER JOIN stylist_services on stylists.phone_num = stylist_services.stylist_phone
INNER JOIN services on stylist_services.service_name = services.name;