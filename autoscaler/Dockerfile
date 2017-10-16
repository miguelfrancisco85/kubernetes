FROM python:2.7
MAINTAINER "TSR Agent"
#RUN apt-get update && apt-get install wget python-pip python-flask python-requests python-mysqldb -y
RUN mkdir /opt/frontend
RUN chmod 755 /opt/frontend
WORKDIR /opt/frontend
#RUN wget https://storage.googleapis.com/autoscaler-demo/frontend.py -O /opt/frontend/frontend.py
ADD frontend.py /opt/frontend/frontend.py
RUN cat /opt/frontend/frontend.py

ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ] 
#CMD [ "python", "/opt/frontend/frontend.py &" ]

