################################################################################
##                          Class Project                                     ##
################################################################################

# This class project is to test your knowledge of SELECT statement

################################################################################
##                                  PopRunner caselet                         ##
################################################################################

# This script is based on the PopRunner data - PopRunner is an online retailer
# Use the caselet and data (consumer.csv, pop_up.csv, purchase.csv, email.csv) 
# on D2L to answer questions below
# In this script, we will use SQL to do descriptive statistics
# Think about the managerial implications as you go along

options(warn=-1) # R function to turn off warnings
library(sqldf)

################################################################################

# Read the data in: consumer, pop_up, purchase and email tables

# set your working directory and use read.csv() to read files

setwd("C:/Users/julia/Downloads")

consumer<-read.csv("consumer (2).csv",header=TRUE)
pop_up<- read.csv("pop_up.csv",header=TRUE)
purchase<-read.csv("purchase (2).csv",header=TRUE)
email<-read.csv("email.csv",header=TRUE)


# Let us first start with exploring various tables

################################################################################

# Using SQL's LIMIT clause, display first 5 rows of all the four tables

# observe different rows and columns of the tables

################################################################################

# Query 1) Display first 5 rows of consumer table

sqldf("
      SELECT * FROM consumer LIMIT 5
      ")

################################################################################

# Query 2) Display first 5 rows of pop_up table

sqldf("
      SELECT * FROM pop_up LIMIT 5
      ")

################################################################################

# Query 3) Display first 5 rows of purchase table

sqldf("
      SELECT * FROM purchase LIMIT 5
      ")

################################################################################

# Query 4) Display first 5 rows of email table

sqldf("
      SELECT * FROM email LIMIT 5
      ")

################################################################################

# Now, let's look at the descriptive statistics one table at a time: consumer table

# Query 5: Display how many consumers are female and male (column alias: gender_count), 
#          also show what is the average age (column alias: average_age) of consumers by gender

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY gender

sqldf("
      SELECT COUNT(*) AS gender_count,
      AVG(age) AS average_age,
      gender FROM consumer
      GROUP BY gender
      ")

# Interpret your output in simple English (1-2 lines): 
      # There are 6,903 Females and 2,129 Males
      # The average age of Females is 30.61220 and for Males is 32.45186

################################################################################

# Query 6: How many consumers are there in each loyalty status group (column alias: loyalty_count), 
# what is the average age (column alias: average_age) of consumers in each group

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        AVG(<column name>) AS <new column name>,
#        <grouping variable 1> FROM <table name> 
# GROUP BY <grouping variable 1>

# Hint: you will GROUP BY loyalty_status

sqldf("
      SELECT COUNT(*) AS loyalty_count,
      AVG(age) AS average_age,
      loyalty_status FROM consumer 
      GROUP BY loyalty_status
      ")

# Interpret your output in simple English (1-2 lines):
    # In loyalty status 0 there are 1529 people with avg age of 29.37
    # In loyalty status 1 there are 1740 people with avg age of 30.1
    # In loyalty status 2 there are 2612 people with avg age 30.7
    # In loyalty status 3 there are 1385 people with avg age of 31.6
    # In loyalty status 4 there are 1766 people with avg age of 33.51

################################################################################

# Next, let's look at the pop_up table

# Query 7: How many consumers (column alias: consumer_count) who received a
# pop_up message (column alias: pop_up)
# continue adding discount code to their card (column alias: discount_code) 
# opposed to consumers who do not receive a pop_up message

# Syntax: 

# SELECT COUNT(*) AS <new column name>,
#        <grouping variable 1> AS <new column name>, 
#        <grouping variable 2> AS <new column name> FROM <table name> 
# GROUP BY <grouping variable 1>, <grouping variable 2>

# Hint: you will use two grouping variable: GROUP BY pop_up, saved_discount

sqldf("
      SELECT COUNT(*) AS consumer_count,
      pop_up AS pop_up,
      saved_discount AS discount_code FROM pop_up
      GROUP BY pop_up, saved_discount
      ")

# Interpret your output in simple English (1-2 lines):
    # There are 4,516 customers who that did not receive a pop up or save the discount code
    # There are 3,029 customers who received the pop up ad and did NOT save the discount
    # There are 1,487 customers who received the pop up and saved the discount code

################################################################################

# This is purchase table

# Query 8: On an average, how much did consumers spend on their 
# total sales (column alias: total_sales) during their online purchase

# Syntax:

# SELECT AVG(<column name>) AS <new column name> FROM <table name>

sqldf("
      SELECT AVG(sales_amount_total) AS total_sales FROM purchase
      ")

# Interpret your output in simple English (1-2 lines):
    # the average amount spent on total sales is 135.2142

################################################################################

# Finally, let's look at the email table

# Query 9: How many consumers (column alias: consumer_count) of the total opened the email blast

# Syntax:

# SELECT COUNT(*) AS <new column name>,
#       <group variable 1> from <table name> 
#   GROUP BY <group variable 1>


sqldf("
      SELECT COUNT(*) AS consumer_count,
      opened_email from email
      GROUP BY opened_email
      ")

# Interpret your output in simple English (1-2 lines):
      # 8,316 did not open the email
      # 716 opened the email

######################################################################################################

# Now we will combine/ merge tables to find answers

# Query 10: Was the pop-up advertisement successful? Mention yes/ no. 
# In other words, did consumers who received a pop_up message buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales)
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY pop_up
# Inner join on purchase and pop_up table on consumer_id

sqldf("
      SELECT SUM(sales_amount_total) AS sum_sales,
      AVG(sales_amount_total) AS avg_sales, pop_up
      FROM pop_up, purchase
      WHERE pop_up.consumer_id=purchase.consumer_id
      GROUP BY pop_up
      ")

# Interpret your output in simple English (1-2 lines):
      # When the customer did NOT get a pop up w discount the avg sales were $138.69 and sum was $626,324.5
      # When the customer got a pop up w discount avg sales were $131.74 and sum was $594,929.8

######################################################################################################

# Query 11) Did the consumer who spend the least during online shopping opened the pop_up message? Use nested queries.

# Write two separate queries 

# Query 11.1) Find the consumer_id who spent the least from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> LIMIT 1)

# Note: Here I am expecting details of only one consumer with minimum purchase. 
# Therefore, LIMIT 1. There are many consumers with sales_amount_total = 0, 
# however, you need information of any one for your second part of the project.

sqldf("SELECT consumer_id FROM purchase
      ORDER BY sales_amount_total LIMIT 1
      ")

      #5887286353 consumer ID

# Query 11.2) Use the consumer_id from the previous SELECT query to find if the consumer received a pop_up message from the pop_up table

sqldf("SELECT pop_up FROM pop_up
        WHERE consumer_id=5887286353 
      ")
          # the consumer did not receive a pop up

# Query 11.3) Using ? for inner query, create a template to write nested query

sqldf("SELECT pop_up FROM pop_up
        WHERE consumer_id=(?)
      ")

# Query 11.4) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id = 
#      (inner query from Query 11.1)


sqldf("SELECT pop_up FROM pop_up
        WHERE consumer_id=(SELECT consumer_id FROM purchase 
        ORDER BY sales_amount_total LIMIT 1)
      ")
      

# Interpret your output in simple English (1-2 lines):
      # The consumer that spent the least did not receive a pop up message

######################################################################################################

# Query 12: Was the email blast successful? Mention yes/ no. 
# In other words, did consumers who opened the email blast buy more

# Syntax:

# SELECT SUM(<column name>) AS <new column name>,
#        AVG(<column name>) AS <new column name>, 
#        <grouping variable 1> from <table 1>, <table 2>
#      WHERE <table 1>.<key column>=<table 2>.<key column> 
#      GROUP BY <grouping variable 1>

# Hint: you will calculate SUM of sales_amount_total (column alias: sum_sales) 
# and AVG of sales_amount_total (column alias: avg_sales)
# GROUP BY opened_email
# Inner join on purchase and email table on consumer_id

sqldf("
      SELECT SUM(sales_amount_total) AS sum_sales,
      AVG(sales_amount_total) AS avg_sales,opened_email
      FROM purchase, email
      WHERE purchase.consumer_id=email.consumer_id
      GROUP BY opened_email
      ")

# Interpret your output in simple English (1-2 lines):
      # Consumers that did NOT open email had sum of sales of $1,048,822 and avg of $126.121
      # Consumers that did open the email had sum of sales of $172,432 and average of $240.83

######################################################################################################

# Query 13) Did the consumer who spend the most during online shopping opened the email message? Use nested queries.

# Write two separate queries 

# Query 13.1) Find the consumer_id who spent the most from the purchase table

# you can use ORDER BY and LIMIT clause together

# Syntax: 

# SELECT <column name> FROM <table name>
# ORDER BY <column name> DESC LIMIT 1)

sqldf("
      SELECT consumer_id FROM purchase
      ORDER BY sales_amount_total DESC LIMIT 1
      ")
            # consumer_id is 5955534353             

# Query 13.2) Use the consumer_id from the previous SELECT query to find if the consumer opened the email from the email table

sqldf("
      SELECT opened_email FROM email
      WHERE consumer_id=5955534353
      ")
          # The consumer opened the email

# Query 13.3) Using ? for inner query, create a template to write nested query

sqldf("
      SELECT opened_email FROM email
      WHERE consumer_id=(?)
      ")

# Query 13.4) Replace ? with the inner query

# Syntax:

# SELECT <column name 1>, <column name 2> FROM <table name> WHERE consumer_id IN 
#      (inner query from Query 13.1)


sqldf("
      SELECT opened_email FROM email
      WHERE consumer_id=(SELECT consumer_id FROM purchase
      ORDER BY sales_amount_total DESC LIMIT 1)
      ")

# Interpret your output in simple English (1-2 lines):
        # The consumer that spent the most online shopping opened the email ad


######################################################################################################
# Best Luck!
######################################################################################################

