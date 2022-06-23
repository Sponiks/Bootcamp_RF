from robot.libraries.BuiltIn import BuiltIn
from JsonValidator import JsonValidator
class Customers_Products:

    builtin_lib = BuiltIn()
    js = JsonValidator()

    def get_postgresql_lib(self):
        return self.builtin_lib.get_library_instance("DB")

    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    def get_columns_from_customers_and_products_from_postgRest(self, alias, params, expected_status):
        result = self.get_requests_lib().get_on_session(alias=alias, url='/cust_hist?', params=params, expected_status=expected_status)
        address = self.js.get_elements(result.json(), '$..address1')
        email = self.js.get_elements(result.json(), '$..email')
        title = self.js.get_elements(result.json(), '$..title')
        price = self.js.get_elements(result.json(), '$..price')
        return address, email, title, price

    def get_columns_from_customers_and_products_from_DB(self, age, state):
        sql = """SELECT customers.address1, customers.email, products.title, products.price
                            FROM bootcamp.customers
                            JOIN bootcamp.cust_hist ON customers.customerid = cust_hist.customerid
                            JOIN bootcamp.products ON cust_hist.prod_id = products.prod_id
                            WHERE customers.age > %(age)s AND customers.state = %(state)s"""
        params = {"age": age, "state": state}
        return self.get_postgresql_lib().execute_sql_string_mapped(sql, **params)

    def get_columns(self, data: list):
        address_db = []
        email_db = []
        title_db = []
        price_db = []
        for i in data:
            address_db.append(i['address1'])
            email_db.append(i['email'])
            title_db.append(i['title'])
            price_db.append(float(i['price']))
        return address_db, email_db, title_db, price_db