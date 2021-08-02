SET SERVEROUTPUT ON SIZE UNLIMITED

-- Declare object type for 'car'
CREATE OR REPLACE TYPE car IS OBJECT (
  brand       VARCHAR2(30) -- car brand name
, model       VARCHAR2(30) -- car model
, color       VARCHAR2(30) -- car color
, milage           NUMBER  -- milage covered
, status      VARCHAR2(30) -- status of the car (new or used)
, car_state   VARCHAR2(50) -- state of the car (in motion or stationary)
, CONSTRUCTOR FUNCTION car (
  brand      VARCHAR2 -- car brand name
, model      VARCHAR2 -- car model
, color      VARCHAR2 -- car color
, milage      NUMBER  -- milage covered
, status     VARCHAR2 -- status of the car (new or used)
, car_state  VARCHAR2 -- state of the car (in motion or stationary)
) RETURN SELF AS RESULT
, MEMBER PROCEDURE display_car
);
/

-- Implement object type 'car'
CREATE OR REPLACE TYPE BODY car IS 
  -- Defining the explicit constructor
  CONSTRUCTOR FUNCTION car (
    brand      VARCHAR2 -- car brand name
  , model      VARCHAR2 -- car model
  , color      VARCHAR2 -- car color
  , milage      NUMBER  -- milage covered
  , status     VARCHAR2 -- status of the car (new or used)
  , car_state  VARCHAR2 -- state of the car (in motion or stationary)
  ) RETURN SELF AS RESULT IS
  
  BEGIN
    -- Pass actual attributes to class variables
    SELF.brand      := brand;
	SELF.model      := model;
	SELF.color      := color;
	SELF.milage     := milage;
	SELF.status     := status;
	SELF.car_state  := car_state;
	RETURN;
  END car;
  
  -- Defining the member 'display_car'
  MEMBER PROCEDURE display_car IS
  BEGIN
    -- Read the instance of class instance variables
    DBMS_OUTPUT.PUT_LINE('The car details is as follows:');
	-- Displaying the values of the object type attributes
	DBMS_OUTPUT.PUT_LINE('Brand: ' || SELF.brand);
	DBMS_OUTPUT.PUT_LINE('Model: ' || SELF.model);
	DBMS_OUTPUT.PUT_LINE('Color: ' || SELF.color);
	DBMS_OUTPUT.PUT_LINE('Milage: ' || SELF.milage);
	DBMS_OUTPUT.PUT_LINE('Status: ' || SELF.status);
	DBMS_OUTPUT.PUT_LINE('State: ' || SELF.car_state);
  END display_car;
END;
/

-- Anonymous block to call the object type
DECLARE
  lv_car car;
BEGIN
  -- Sets the lv_car as object type of 'car'
  lv_car := car('Toyota', 'Yaris', 'White', 1200, 'Used', 
  'The car is in motion');
  /*
    Statement 'lv_car.display_car' called the 'display_car' member 
	function and the attributes values are displayed
  */
  lv_car.display_car;
END;
/