#imports
import pandas as pd
import pyodbc
import numpy as np
import csv
import pygsheets

#Function to create files
#scCMD: school additional sql command
def creator(scCMD, csvFile):
    # connection
    conn = pyodbc.connect('Driver={SQL Server};'
    'Server=MHU-DBWH;'
    'Database=Aeries;'
    'Trusted_Connection=yes;')
    # start connection

    cursor = conn.cursor()

    file = open('C:/Users/Prashan.Welipitiya/Documents/Prashan/MTSS/MTSS_Data.sql', 'r')
    sqlFile = file.read()
    file.close()

    cursor.execute(sqlFile + scCMD)
    data = cursor.fetchall()

    with open(csvFile, 'w', newline='') as fp:
        a = csv.writer(fp, delimiter=',')
        a.writerow([column[0] for column in cursor.description])
        for line in data:
            a.writerow(line)

    # for row in data:
    #     print (row[0], row[1], row[2])

    cursor.close()
    conn.close()

    # edit csv
    df = pd.read_csv(csvFile, encoding = "ISO-8859-1")

    #colName - Header Name
    #val = Condition value.
    #riskFactor = rounded number to add to collumn
    def editCol(colName, val, riskFactor):
        if df.loc[i, colName] == val:
            riskList[i] = riskList[i] + riskFactor

    # For MAP I'm using last recorded score instead of TA = Winter. Trying to have less null values.
    # Because of that, I'm using percentile instead of scaled score because of the variances between scaled scores per TA.
    # MAP states that, "Based on 2008 RIT Norms, LO is equal to percentile scores < 33" for each TA.
    def MAP(colName, riskFactor):
        if df.loc[i, colName] < 33 and df.loc[i, colName] > 0:
            riskList[i] = riskList[i] + riskFactor

    # Question: Are we only using suspension for current year? Also are we for sure maxing out at a score of 9?
    def suspension():
        x = min(9, (df.loc[i, "Days Suspended"] * 2))
        riskList[i] = riskList[i] + x

    # For expulsions, are we maxing out at 9?

    def truancies():
        if df.loc[i, "Truant"] > 9:
            riskList[i] = riskList[i] + 9
        elif df.loc[i, "Truant"] > 6:
            riskList[i] = riskList[i] + 6
        elif df.loc[i, "Truant"] > 3:
            riskList[i] = riskList[i] + 3

    def tardies():
        t = min(7, (df.loc[i, "Tardies"]//3))
        riskList[i] = riskList[i] + t

    def credits(grade, credits):
        if df.loc[i, "Grade"] == grade and df.loc[i, "Number of Credits"] < credits:
            riskList[i] = riskList[i] + 7

    def ELPAC(test):
        if df.loc[i, test] == 1:
            riskList[i] = riskList[i] + 7
        elif df.loc[i, test] == 2:
            riskList[i] = riskList[i] + 3
        elif df.loc[i, test] == 3:
            riskList[i] = riskList[i] + 1

    def GPA():
        if df.loc[i, "Grade"] > 5 and df.loc[i, "GPA"] <= 1 and df.loc[i, "GPA"] > 0:
            riskList[i] = riskList[i] + 7
        elif df.loc[i, "Grade"] > 5 and df.loc[i, "GPA"] <= 2:
            riskList[i] = riskList[i] + 4
        elif df.loc[i, "Grade"] > 5 and df.loc[i, "GPA"] <= 3:
            riskList[i] = riskList[i] + 1

    riskList = []
    x = 0
    for i in range(len(df)):
        riskList.append(0)
        editCol("Foster", "Y", 9)
        editCol("Homeless", "Y", 9)
        editCol("LangFluency", "L", 7)
        editCol("Long Term EL", "Y", 8)
        editCol("SocioEcoStatus", "Y", 8)
        editCol("SPED", "Y", 8)
        MAP("MAP_ELA", 7)
        MAP("MAP_Math", 6)
        suspension()
        editCol("Expelled", "Y", 9)
        editCol("Race", "Hispanic", 6)
        editCol("Race", "Black or African American", 6)
        editCol("Race", "White", 4)
        editCol("Race", "Asian", 4)
        editCol("Race", "Pacific Islander", 4)
        editCol("Race", "American Indian or Alaskan Native", 4)
        # Is there a reason for having multiethnic at a score of 5?
        editCol("Student Self Harm", "Y", 9)
        editCol("ChronicAbs", "Y", 9)
        truancies()
        tardies()
        credits(9,55)
        credits(10,110)
        credits(11,165)
        credits(12,220)
        ELPAC("Oral_Perf")
        ELPAC("Written_Perf")
        ELPAC("Listening_Perf")
        ELPAC("Speaking_Perf")
        ELPAC("Reading_Perf")
        ELPAC("Writing_Perf")
        editCol("LangFluency", "R", 5)
        editCol("Gender", "M", 5)
        GPA()
        editCol("Retained", "Y", 7)

        df.loc[i,'Risk Factor'] = riskList[i]

    # Add Tier collumn
    tier = []
    y = 0

    def tierRange():
        if df.loc[i,'Risk Factor'] >= 0 and df.loc[i,'Risk Factor'] < 25:
            tier[i] = "Tier 1"
        elif df.loc[i,'Risk Factor'] >= 25 and df.loc[i,'Risk Factor'] < 75:
            tier[i] = "Tier 2"
        else:
            tier[i] = "Tier 3"

    for i in range(len(df)):
        tier.append(0)
        tierRange()
        df.loc[i, 'Tier Range'] = tier[i]

    # df.to_csv(csvFile)

    gc = pygsheets.authorize(service_file='/Users/Prashan.Welipitiya/desktop/MTSS-36c7376b8db8.json')
    #open the google spreadsheet
    sh = gc.open('MTSS Data Warehouse')
    #select the first sheet
    wks = sh[0]
    wks.resize(rows = len(df.index))
    #update the first sheet with df, starting at cell B2.
    wks.set_dataframe(df,(1,1), nan = '')


#School Codes
elToro = "AND STU.SC = 2"
losPaseos = "AND STU.SC = 6"
nordstrom = "AND STU.SC = 8"
paradise = "AND STU.SC = 9"
SMG = "AND STU.SC = 10"
Walsh = "AND STU.SC = 11"
Barrett = "AND STU.SC = 12"
JAMM = "AND STU.SC = 15"
#Create Files
creator(DIST, "MTSS.csv")
# creator(elementary, "MTSSK_5.csv")
# creator(middle, "MTSS6_8.csv")
# creator(high, "MTSS9_12.csv")
# creator(elToro, "MTSSelToro.csv")
# creator(losPaseos, "MTSSlosPaseos.csv")
# creator(nordstrom, "MTSSnordstrom.csv")
# creator(paradise, "MTSSparadise.csv")
# creator(SMG, "MTSS_SMG.csv")
# creator(Walsh, "MTSSWalsh.csv")
# creator(Barrett, "MTSSBarrett.csv")
# creator(JAMM, "MTSS_JAMM.csv")
# creator(Britton, "MTSSbrit.csv")
# creator(Murphy, "MTSMurphy.csv")
# creator(Central, "MTSSCentral.csv")
# creator(LO, "MTSSLO.csv")
# creator(SOB, "MTSSSOB.csv")
