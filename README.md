# PortSwigger SQL Injection Bash Script


This repository contains a Bash script that demonstrates SQL injection techniques using SQL Injection Labs on PortSwigger.
> https://portswigger.net/web-security/sql-injection/blind/lab-conditional-responses
> 
> https://portswigger.net/web-security/sql-injection/blind/lab-conditional-errors
> 
> https://portswigger.net/web-security/sql-injection/blind/lab-time-delays-info-retrieval


## To run the script, you need the following:

    Bash shell environment
    cURL command-line tool
    Access to a vulnerable web application for testing (SQL Injection Labs on PortSwigger)

## Usage

# To execute the script, use the following command:

```bash
./portswiggersqli.sh [flag]
```

Available flags:

    -r: Lab - Blind SQL injection with conditional responses
    -e: Lab - Blind SQL injection with conditional errors (Oracle)
    -t: Lab - Blind SQL injection with time delays and information retrieval (PostgreSQL)
    -h: Help
    
# Example usage:

```bash
./portswiggersqli.sh -r
```
Next, you will be prompted to enter the following information:

> Please enter a valid URL: [enter the URL]
-------------------------
> Please enter a valid session (Check your browser's cookies): [enter the session]
-------------------------
> Please enter a valid TrackingId: [enter the TrackingId]
-------------------------
Please ensure that you replace [enter the URL], [enter the session], and [enter the TrackingId] with the actual values you want to use [!!!]Check your browser's cookies.

![2023-05-18-115626_1455x507_scrot](https://github.com/kvlx-alt/PortSwigger-SQL-Injection-Bash-Script/assets/118694485/2fdce536-a9c9-4575-9d27-c975fe9963ed)


## Important Note

This script should only be used for educational purposes or with explicit permission from the target application's owner. Unauthorized use of this script on live systems is strictly prohibited.


## For more information on SQL injection and web security testing, refer to the following resources:

> PortSwigger Academy https://portswigger.net/web-security/sql-injection 
-----------------------------
> SQL injection cheat sheet https://portswigger.net/web-security/sql-injection/cheat-sheet

## Disclaimer

The author of this script is not responsible for any misuse or damages caused by its usage. Use at your own risk.

Feel free to modify and enhance the script as needed. Contributions are welcome!
