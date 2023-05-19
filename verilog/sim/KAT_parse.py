import sys
import os

f1=open('CBCVarTxt256.rsp',"r")	
f2 = open('KAT_256.rsp', 'w')
c=0
lf=""
Lines=f1.readlines()

for a in Lines:
	if a[0:6] =="KEY = ":
		lf=a[6:261]
		f2.write(lf)

	if a[0:5] =="IV = ":
		lf=a[5:261]
		f2.write(lf)

	if a[0:12] =="PLAINTEXT = ":
		lf=a[12:139]
		f2.write(lf)
		
	if a[0:13] =="CIPHERTEXT = ":
		lf=a[13:140]
		f2.write(lf)
		
		
	
f2.close()
f1.close()
f3 = open('KAT_256_03.rsp', 'r')
L=f3.readlines()
for k in L:
	print(k)
f3.close()


#f4 = open('KAT_256.rsp', 'r')
#Ln=f4.readlines()
#for u in Ln:
#	print(k)
#f3.close()


            
