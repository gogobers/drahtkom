clear all;
close all;
% GSM-Paging Channel (Hambrücken)
%system('./rx_samples_to_file --freq 934.6e6 --rate 2e6 --gain 40 --time 0.001 first.dat');
system('./rx_samples_to_file --freq 900.0e6 --rate 8e6 --gain 45 --time 0.001');
sps=8;
rolloff=0.22; span=16;
s=1000*sps;
% WLAN Channel
chan=6;
%inst=sprintf('./rx_samples_to_file --freq %e --rate %d --gain 40 --time 0.01 first.dat',2407e6+5e6*chan,40e6);
%inst
%system(inst);
fid=fopen('usrp_samples.dat'); a=fread(fid,'int16'); fclose(fid);
ii=a(1:2:end);
qq=a(2:2:end);
figure(13); clf; hold on;
plot(ii([s+1:s+100*sps]),'b');
plot(qq([s+1:s+100*sps]),'r');

rxSig=ii+1i*qq;
rxSig=rxSig/max(abs(rxSig));
figure(2); clf;hold on;
plot(10*log10(fftshift(abs(fft(rxSig)))));

symbolSync = comm.SymbolSynchronizer(...
    'TimingErrorDetector','Zero-Crossing (decision-directed)',...
    'SamplesPerSymbol',sps);

b = rcosdesign(rolloff, span, sps,'sqrt');
rxSig_f = upfirdn(rxSig, b, 1, 1);
rxSig_f=rxSig_f(sps*span/2+1:end-sps*span/2);
figure(1); clf; hold on;
plot(real(rxSig_f([s+1:s+100*sps])),'b--');
plot(imag(rxSig_f([s+1:s+100*sps])),'r--');
scatterplot(rxSig_f(floor(9801):floor(10001)));
%rxSig_f=[0;rxSig_f];%r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];%r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));
%rxSig_f=[0; rxSig_f];r=upfirdn(rxSig_f,1,1,sps);scatterplot(r(floor(9801):floor(10001)));

figure(2); 
plot(10*log10(fftshift(abs(fft(rxSig_f)))),'r');

%demod = comm.QPSKDemodulator;
cfc = comm.CoarseFrequencyCompensator('Modulation','QPSK',...
    'SampleRate',8e6,'FrequencyResolution',1e1);
[syncCoarse,fo] = step(cfc,rxSig_f);
fo
figure(1);
plot(real(syncCoarse([s+1:s+100*sps])),'b.-');
plot(imag(syncCoarse([s+1:s+100*sps])),'r.-');
scatterplot(syncCoarse(floor(9801):floor(10001)));
title('Grobe Synchronisation');

csync = comm.CarrierSynchronizer(...
    'SamplesPerSymbol',sps, ...
    'Modulation','QPSK',...
    'DampingFactor',0.2,...
    'NormalizedLoopBandwidth',0.0002);
[rxData,P] = step(csync,syncCoarse);
figure(12); plot(P);
% rxData = step(csync,rxSig_f);
%rxData=syncCoarse;
figure(1);
plot(real(rxData([s+1:s+100*sps])),'b^-');
plot(imag(rxData([s+1:s+100*sps])),'r^-');
% figure(6);clf; hold on;
% plot(real(rxData([end-100*sps:end])),'b.-');
% plot(imag(rxData([end-100*sps:end])),'r.-');
scatterplot(rxData(9001:10000));
title('CarrierSynchronizer (Fine)');

rxData=rxData/max(abs(rxData))/sqrt(2);
symSync=step(symbolSync,rxData);
isLocked(symbolSync)
length(rxData)
length(symSync)
figure(11);clf; hold on;
plot(real(symSync([s/sps+1:s/sps+100])),'y^');
plot(imag(symSync([s/sps+1:s/sps+100])),'g^');

%scatterplot(symSync([5+20*sps:sps:end]));
scatterplot(symSync([s/sps+1:s/sps+100]));



