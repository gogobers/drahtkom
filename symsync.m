txfilter = comm.RaisedCosineTransmitFilter( ...
    'OutputSamplesPerSymbol',8);
rxfilter = comm.RaisedCosineReceiveFilter( ...
    'InputSamplesPerSymbol',8, ...
    'DecimationFactor',1);
fixedDelay = dsp.Delay(20);
symbolSync = comm.SymbolSynchronizer('SamplesPerSymbol',8);
data = randi([0 3],5000,1);
modSig = pskmod(data,4,pi/4);
txSig = step(txfilter,modSig);
delaySig = step(fixedDelay,txSig);
rxSig = awgn(delaySig,5,'measured');
rxSample = step(rxfilter,rxSig);
scatterplot(rxSample(1001:end),2)
rxSync = step(symbolSync,rxSample);
scatterplot(rxSync(1001:end),2)

