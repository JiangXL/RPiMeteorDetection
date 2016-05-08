# RPiMeteorDetection
Auto Meteor Detection with Raspberry Pi
CompanyAstronmy Aaccoidatio of South University of Science and Technology of China 

Why:   

How:









Date Store:
  We use baidu yun(Personal Storage) to store date.
  github homepage of bypy: https://github.com/houtianze/bypy.
  install command（ubuntu or others）:
    sudo pip install requests
    sudo pip install bypy
    
  Run bypy:
  first time I need to run auth,use command like that:
  bypy info
  then 
  To get more details about certain command:
   bypy.py help <command>
   List files at (App's) root directory at Baidu PCS:
   bypy.py list
   To sync up to the cloud (from the current directory):
   bypy.py syncup
   or bypy.py upload
   To sync down from the cloud (to the current directory):
   bypy.py syncdown 
   or bypy.py downdir /
  
