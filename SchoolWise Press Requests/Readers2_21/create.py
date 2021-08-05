#imports
import pandas as pd
import pyodbc
import numpy as np
import csv
import openpyxl
import pygsheets

# SQL File
file = open('data.sql', 'r')
sqlFile = file.read()
file.close()

def pull(db, scyear, stdate, endate, fallst, fallen, sprgst, sprgen, sbac, output):

    # Connect to database
    conn = pyodbc.connect('Driver={SQL Server};'
    'Server=MHU-DBWH;'
    'Database='+ db +';'
    'Trusted_Connection=yes;')

    # Run SQL query with connection and store in dataframe.
    writer = pd.ExcelWriter(output,engine='xlsxwriter')
    workbook=writer.book
    worksheet=workbook.add_worksheet('data')
    writer.sheets['data'] = worksheet

    variables = "DECLARE @SchoolYear VARCHAR(30), @StartDate VARCHAR(30), @EndDate VARCHAR(30), @Dys VARCHAR(30), @MAPFallStart VARCHAR(30), @MAPFallEnd VARCHAR(30), @MAPSpringStart VARCHAR(30), @MAPSpringEnd VARCHAR(30), @SBAC VARCHAR(30);"
    schoolyear = "SET @SchoolYear =" + scyear + ";"
    startdate = "SET @StartDate =" + stdate + ";"
    enddate = "SET @EndDate =" + endate + ";"
    mapfallstart = "SET @MAPFallStart =" + fallst + ";"
    mapfallend = "SET @MAPFallEnd =" + fallen + ";"
    mapspringstart = "SET @MAPSpringStart =" + sprgst + ";"
    mapspringend = "SET @MAPSpringEnd =" + sprgen + ";"
    caaspp = "SET @SBAC =" + sbac + ";"

    bl = pd.read_sql_query(variables + schoolyear + startdate + enddate + mapfallstart + mapfallend + mapspringstart + mapspringend + caaspp + sqlFile, conn)
    bl.to_excel(writer,sheet_name='data',startrow=1 , startcol=1, index = False)

pull('Aeries', "'2020-2021'", "'7/1/2020'", "'6/30/2021'", "'8/01/2020'", "'10/31/2020'", "'11/01/2020'", "'03/31/2021'", "'SPRG21'", 'data.xlsx')
