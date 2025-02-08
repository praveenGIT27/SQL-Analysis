CREATE DATABASE IF NOT EXISTS brazilian_ecommerce;
USE DATABASE brazilian_ecommerce;

CREATE SCHEMA ecommerce_schema;
USE SCHEMA ecommerce_schema;


SHOW DATABASES;
SHOW SCHEMAS IN DATABASE brazilian_ecommerce;

CREATE OR REPLACE STAGE ecommerce_stage;

LIST @ecommerce_stage;
