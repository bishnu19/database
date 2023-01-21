"""
CS3810: Principles of Database Systems
Instructor: Thyago Mota
git practice is going on.
"""

class Entity: 
    """
    models an entity's interface with a key
    """

    def get_key(self) -> any:
        """
        defines a method to return an entity's key (used for search purposes)
        """
        pass

class Employee(Entity): 
    """
    models an employee entity with id, name, and department
    """

    def __init__(self, id, name, department) -> None:
        self.id          = id 
        self.name        = name
        self.department  = department

    def get_key(self): 
        """
        an employee's id is defined as the entity's key
        """
        return self.id

    def __str__(self) -> str:
        """
        returns a string representation of an employee object in csv style
        """
        return str(self.id) + "," + self.name + "," + self.department

class CRUD: 
    """
    models a CRUD (Create, Read, Update, and Delete) interface
    """

    def create(self, entity) -> bool: 
        """
        defines a method to create a new entity
        """
        pass

    def read(self, key) -> any: 
        """
        defines a method to search for an entity by its key
        """
        pass 

    def update(self, entity) -> bool: 
        """
        defines a method to update an entity
        """
        pass

    def delete(self, key) -> bool: 
        """
        defines a method to delete an entity by its key
        """
        pass

class EmployeeCRUD(CRUD): 
    """
    models a CRUD for employee entities
    """

    def __init__(self, file_name): 
        """
        an employee CRUD is defined by its file name (used for storage)
        """
        self.file_name = file_name

    def create(self, entity) -> bool:
        """
        an employee entity should only be created if it does not exist
        """
        key = entity.get_key()
        result = False
        if not self.read(key): 
            try: 
                file = open(self.file_name, "a")
                file.write(str(entity) + "\n")
                result = True
            finally: 
                file.close()
        return result

    def read(self, key) -> Employee: 
        """
        TODO #1: 
            * open the (storage) file for reading
            * perform a linear search for the entity using the provided key
            * if the entity is found, return it
            * else, return None
        """
        employee = None
        try: 
            file = open(self.file_name, "r")
            for line in file: 
                line = line.strip()
                cols = line.split(",")
                id = int(cols[0])
                print("id:" + str(id))
                print("key: " + str(key))
                if id == key:
                    name = cols[1]
                    department = cols[2]
                    employee = Employee(id, name, department)
                    break
        finally:
            file.close()
        return employee

    def update(self, entity) -> bool: 
        """
        TODO #2: delete the entity (using the key) then re-create it
        """
        key = entity.get_key()
        if not self.delete(key): 
            return False
        if not self.create(entity):
            return False
        return True

    def delete(self, key) -> bool: 
        """
        TODO #3: 
            * open the (storage) file for reading
            * read all of the lines in memory
            * re-open the (storage) file for writing
            * copy all of the entities, except the one that should be deleted
        """
        result = False
        try: 
            file = open(self.file_name, "r")
            lines = file.readlines()
            file.close()
            file = open(self.file_name, "w")
            for line in lines: 
                line = line.strip()
                cols = line.split(",")
                id = int(cols[0])
                if id == key:
                    continue
                file.write(line + "\n")
            result = True
        finally: 
            file.close()
        return result
                
def menu(): 
    print("1. Create")
    print("2. Read")
    print("3. Update")
    print("4. Delete")
    print("5. Quit")

FILE_NAME = "employees.csv" 
    
if __name__ == "__main__":

    empCRUD = EmployeeCRUD(FILE_NAME)
    while (True):
        menu()
        option = int(input("? "))
        if option == 1:
            id = int(input("id? "))
            name = input("name? ")
            department = input("department? ")
            employee = Employee(id, name, department)
            if empCRUD.create(employee): 
                print("New employee successfully created!")
            else:
                print("Fail to create a new employee!")
        elif option == 2:
            id = int(input("id? "))
            employee = empCRUD.read(id)
            if employee: 
                print(employee)
            else:
                print("Employee not found!")
        elif option == 3: 
            id = int(input("id? "))
            name = input("name? ")
            department = input("department? ")
            employee = Employee(id, name, department)
            if empCRUD.update(employee):
                print("Employee successfully updated!")
            else:
                print("Fail to update employee!")
        elif option == 4: 
            id = int(input("id? "))
            if empCRUD.delete(id):
                print("Employee successfully deleted!")
            else:
                print("Fail to delete employee!")
        elif option == 5:
            break
        else:
            print("Invalid option!")
    print("Bye!")
