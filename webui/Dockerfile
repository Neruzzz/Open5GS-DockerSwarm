FROM node:19

RUN git clone https://github.com/open5gs/open5gs.git

RUN cd open5gs/webui && \
    npm clean-install && \
    npm run build

ADD https://github.com/ufoscout/docker-compose-wait/releases/download/2.9.0/wait /wait
RUN chmod +x /wait

CMD cd open5gs/webui && /wait && npm run dev

EXPOSE 3000