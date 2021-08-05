#imports
import pandas as pd
import pyodbc
import numpy as np
import csv
import openpyxl
import config

# Connect to database

cnxn = pyodbc.connect('Driver={SQL Server};'
'Server=MHU-DBWH;'
'Database=Aeries;'
'Trusted_Connection=yes;')

bl = pd.read_sql_query("SELECT * FROM ATT WHERE SC = 21 AND SN = 4404 AND DEL = 0", cnxn)
print(bl)

conn = pyodbc.connect('Driver={SQL Server};'
'Server='+config.Server+';'
'Database='+config.Database+';'
'UID='+config.UID+';'
'PWD='+config.PWD+';'
)

cursor = conn.cursor()

for index, row in bl.iterrows():
    cursor.execute("INSERT INTO DST20000MorganHill.dbo.ATT (SC,SN,DY,CD,PR,GR,TR,TN,AL,A0,A1,A2,A3,A4,A5,A6,A7,A8,A9,DT,RS,NS,AP1,AP2,HS,IT,NPS,ITD,ADA,ADT,ACO,FA,DEL,DTS) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)", row.SC,row.SN,row.DY,row.CD,row.PR,row.GR,row.TR,row.TN,row.AL,row.A0,row.A1,row.A2,row.A3,row.A4,row.A5,row.A6,row.A7,row.A8,row.A9,row.DT,row.RS,row.NS,row.AP1,row.AP2,row.HS,row.IT,row.NPS,row.ITD,row.ADA,row.ADT,row.ACO,row.FA,row.DEL,row.DTS
)

conn.commit()
cursor.close()
