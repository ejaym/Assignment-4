Teammates: Sarah Haddix, Evan Menendez, William Chesser

The code should be executed as follows:
1. Open 2 seperate terminals
2. Type "erl -sname term1" into the first terminal
3. Type "erl -sname term2" into the second terminal
4. In terminal one type in "net_adm:ping(term2@YOURMACHINEHOSTNAME)" replace YOURMACHINEHOSTNAME with the host name of your machine. This can be found at the beginning of the terminal line after the @ sign.
5. In terminal two type in "net_adm:ping(term1@YOURMACHINEHOSTNAME)" replace YOURMACHINEHOSTNAME with the host name of your machine
6. In terminal one compile and run the code using : "c(server)." then "server:start()."
7. Test the code by inputting functions you would like to use
8. Change the code in the individual servers to have different functionality and save.
9. In terminal 2 type "c(server)." then "{serv1, 'term1@YOURMACHINEHOSTNAME'} ! update". Replace YOURMACHINEHOSTNAME with the host name of your machine. "serv1" will change depending on what function you edited, if you edited serv2 then you should put that down instead of serv1, same goes for serv3.
10. The changes you made to the file should now be running in terminal 1, test the code by running the functions you would like to use.
