# ICS3203-CAT2-Assembly-Gitiche-Emmanuel-Chege-151894

# Overview of each program
## **Task 1: Control Flow and Conditional Logic**  
The purpose of this program is to prompt a user for a number from which 
it is classified between either "POSITIVE" or "NEGATIVE"

## **Task 2: Array Manipulation with Looping and Reversal** 
The purpose of this program is to accept an array if integers
as input , reverse the array and outputs the array 

## **Task 3: Modular Program with Subroutines for Factorial Calculation**  
The purpose of this program is to take a user input which is in integer form and returning 
the Factorial of that number using subroutines

## **Task 4: Data Monitoring and Control Using Port-Based Simulation**
The purpose of this program is to simulate a control system that monitors a sensor value and 
takes action based on input conditions such as turning on a motor ,
triggering an alarm or stopping the motor

# Instructions on compiling and running the programs
1. Install WSL
2. Install Ubuntu on your machine from the playstore if you dont have it as your default OS
3. Enter the terminal of your ubuntu and run this command to install the nasm library (sudo apt-get install -y nasm)
4. Run the following three commands to compile and finally run the asm file
    i.   nasm -g -f elf Task1.asm
    ii.  ld -m elf_i386 -g -o Task1 Task1.o
    iii. ./Task1

# Challenges or Insights encountered in each task
1. I found challenges in compiling the files as they I was getting errors concerning invalid effective address

## Task 1
Ensuring that each branch leads to the correct label 
## Task 2
Handling arrays with an odd number of elements 
## Task 3
Ensuring register values are preserved before subroutine calls
## Task 4
Accurately simulating port based I/O and to ensure memory locations reflect the intended actions
