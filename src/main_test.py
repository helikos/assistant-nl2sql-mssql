import os
from openai import AzureOpenAI
from lib.assistant import AIAssistant
import argparse
import lib.tools_mssql as tools_mssql
import lib.tools_postgres as tools_postgres


def main(env_file, env_name):

    func = tools_mssql.GetDBSchema()
    res = func.function()
    with open("res.txt", 'wb') as f:
        f.write(res.encode())
    print(res)

#    func = tools_mssql.ListTables()
#    print(func.function())

#    func = tools_mssql.FetchDistinctValues()
#    print(func.function("Sales" ,"SalesReason", "name"))
    
#    func = tools_mssql.FetchSimilarValues()
#    print(func.function("HumanResources" ,"Employee", "jobtitle", "research"))

#    func = tools_mssql.FetchSumByColumn()
#    print(func.function("HumanResources" ,"EmployeePayHistory", "rate", "BusinessEntityID"))

#    func = tools_mssql.FetchValuebyId()
#    print(func.function("HumanResources" ,"EmployeePayHistory", "rate", "BusinessEntityID", 1))



if __name__ == "__main__":
    main("", "prod.env")
