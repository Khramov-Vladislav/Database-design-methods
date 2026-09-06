CREATE DATABASE dormitory;
\ c dormitory;
CREATE TABLE building (
    building_id SERIAL PRIMARY KEY,
    building_address VARCHAR(150)
);
CREATE TABLE room_type (
    room_type_id SERIAL PRIMARY KEY,
    type_name VARCHAR(15)
);
CREATE TABLE room (
    room_id SERIAL PRIMARY KEY,
    building_id INT,
    room_type_id INT,
    FOREIGN KEY (building_id) REFERENCES building(building_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (room_type_id) REFERENCES room_type(room_type_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE place (
    place_id SERIAL PRIMARY KEY,
    level INT,
    room_id INT,
    FOREIGN KEY (room_id) REFERENCES room(room_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE student (
    student_id SERIAL PRIMARY KEY,
    last_name VARCHAR(40),
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    passport_data VARCHAR(10)
);
CREATE TABLE employee (
    employee_id SERIAL PRIMARY KEY,
    last_name VARCHAR(40),
    first_name VARCHAR(20),
    middle_name VARCHAR(20),
    passport_data VARCHAR(10),
    position VARCHAR(300)
);
CREATE TABLE payment_method (
    payment_method_id SERIAL PRIMARY KEY,
    method_name VARCHAR(20)
);
CREATE TABLE settlement (
    settlement_id SERIAL PRIMARY KEY,
    student_id INT,
    employee_id INT,
    place_id INT,
    move_in_date DATE,
    move_out_date DATE,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (student_id) REFERENCES student(student_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (place_id) REFERENCES place(place_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE payment (
    payment_id SERIAL PRIMARY KEY,
    settlement_id INT,
    payment_method_id INT,
    payment_amount DECIMAL(10, 2),
    payment_date DATE,
    FOREIGN KEY (settlement_id) REFERENCES settlement(settlement_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES payment_method(payment_method_id) ON DELETE CASCADE ON UPDATE CASCADE
);
CREATE TABLE review (
    review_id SERIAL PRIMARY KEY,
    settlement_id INT,
    comment VARCHAR(250),
    rating INT,
    review_date DATE,
    FOREIGN KEY (settlement_id) REFERENCES settlement(settlement_id) ON DELETE CASCADE ON UPDATE CASCADE
);