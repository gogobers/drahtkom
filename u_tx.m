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
fid=fopen('first.dat','w'); a=fwrite(fid,a,'int16'); fclose(fid);
inst=sprintf('./tx_samples_from_file --freq %e --rate %d --gain 90 --repeat --file first.dat',2407e6+5e6*chan,32e6);
system(inst);
