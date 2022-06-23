from robot.libraries.BuiltIn import BuiltIn
from JsonValidator import JsonValidator
class Category:

    builtin_lib = BuiltIn()
    js = JsonValidator()

    def get_postgresql_lib(self):
        return self.builtin_lib.get_library_instance("DB")

    def get_requests_lib(self):
        return self.builtin_lib.get_library_instance("Req")

    def add_new_data(self, alias, new_data,json):
        self.get_requests_lib().post_on_session(alias=alias, url='/categories?', data=new_data, json=json)

    def get_category_and_categoryname_from_postgRest(self, alias, expected_status):
        result = self.get_requests_lib().get_on_session(alias=alias, url='/categories?', expected_status=expected_status)
        category = self.js.get_elements(result.json(), '$..category')
        categoryname = self.js.get_elements(result.json(), '$..categoryname')
        return category, categoryname

    def get_category_and_categoryname_from_DB(self):
        sql = """SELECT * FROM bootcamp.categories"""
        return self.get_postgresql_lib().execute_sql_string_mapped(sql)

    def get_columns(self, data: list):
        category_db = []
        categoryname_db = []
        for i in data:
            category_db.append(i['category'])
            categoryname_db.append(i['categoryname'])
        return category_db, categoryname_db