% GSM-Paging Channel (Hambrücken)
%system('./rx_samples_to_file --freq 934.6e6 --rate 2e6 --gain 40 --time 0.01 first.dat');
system('./rx_samples_to_file --freq 900.6e6 --rate 1e6 --gain 30 --time 0.001');
% WLAN Channel
chan=6;
%inst=sprintf('./rx_samples_to_file --freq %e --rate %d --gain 40 --time 0.01 first.dat',2407e6+5e6*chan,40e6);
%inst
%system(inst);
fid=fopen('usrp_samples.dat'); a=fread(fid,'int16'); fclose(fid);
ii=a(1:2:end);
qq=a(2:2:end);

figure(1); clf; hold on;
plot(ii,'b');
plot(qq,'r');

ff=ii+1i*qq;
r=abs(ff);
a=angle(ff);

figure(2); clf;
plot(10*log10(fftshift(abs(fft(ff)))));


csync = comm.CarrierSynchronizer('DampingFactor',0.7, ...
    'NormalizedLoopBandwidth',0.005, ...
    'SamplesPerSymbol',sps, ...
    'Modulation','QAM');
rxData = step(csync,rxSig);
step(cd,rxData(9001:10000));
cfc = comm.CoarseFrequencyCompensator('Modulation','QAM','SampleRate',fs);
syncCoarse = step(cfc,rxSig);
rxData = step(csync,syncCoarse);
release(cd)
step(cd,rxData(9001:10000))

