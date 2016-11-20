chan=6;
bits=15;
anz=64e6;
ii=floor(sin(2*pi*[1:anz]/32)*(2^bits-1));
%ii=[1:4000];
qq=-floor(cos(2*pi*[1:anz]/32)*(2^bits-1));
%plot(ii)

a=zeros(1,2*length(ii));
a(1:2:end)=ii;
a(2:2:end)=qq;
fid=fopen('usrp_tx.dat','w'); a=fwrite(fid,a,'int16'); fclose(fid);
inst=sprintf('./txrx_uhd');
system(inst);

fid=fopen('usrp_rx.dat'); a=fread(fid,'int16'); fclose(fid);
ii=a(1:2:end);
qq=a(2:2:end);

figure(1); clf; hold on;
plot(ii,'b');
plot(qq,'r');

ff=ii+1i*qq;
r=abs(ff);
a=angle(ff);
