%hackrf_transfer: invalid option -- '-'
%unknown argument '-? (null)'
%Usage:
%	-r <filename> # Receive data into file.
%	-t <filename> # Transmit data from file.
%	-w # Receive data into file with WAV header and automatic name.
%	   # This is for SDR# compatibility and may not work with other software.
%	[-f freq_hz] # Frequency in Hz [0MHz to 7250MHz].
%	[-i if_freq_hz] # Intermediate Frequency (IF) in Hz [2150MHz to 2750MHz].
%	[-o lo_freq_hz] # Front-end Local Oscillator (LO) frequency in Hz [84MHz to 5400MHz].
%	[-m image_reject] # Image rejection filter selection, 0=bypass, 1=low pass, 2=high pass.
%	[-a amp_enable] # RX/TX RF amplifier 1=Enable, 0=Disable.
%	[-p antenna_enable] # Antenna port power, 1=Enable, 0=Disable.
%	[-l gain_db] # RX LNA (IF) gain, 0-40dB, 8dB steps
%	[-g gain_db] # RX VGA (baseband) gain, 0-62dB, 2dB steps
%	[-x gain_db] # TX VGA (IF) gain, 0-47dB, 1dB steps
%	[-s sample_rate_hz] # Sample rate in Hz (8/10/12.5/16/20MHz, default 10MHz).
%	[-n num_samples] # Number of samples to transfer (default is unlimited).
%	[-c amplitude] # CW signal source mode, amplitude 0-127 (DC value to DAC).
%	[-b baseband_filter_bw_hz] # Set baseband filter bandwidth in MHz.
%	Possible values: 1.75/2.5/3.5/5/5.5/6/7/8/9/10/12/14/15/20/24/28MHz, default < sample_rate_hz.

freq_hz=900e6;
sample_rate_hz=10e6;

chan=6;
bits=8;
anz=65536*16*100;
ii=floor(sin(2*pi*[1:anz]/40)*(2^bits-1));
%ii=[1:4000];
qq=-floor(cos(2*pi*[1:anz]/40)*(2^bits-1));
%plot(ii)

a=zeros(1,2*length(ii));
a(1:2:end)=ii;
a(2:2:end)=qq;
fid=fopen('hack_tx.dat','w'); a=fwrite(fid,a,'int8'); fclose(fid);
inst=sprintf('hackrf_transfer -t hack_tx.dat -f %d -s %d -p 1 -a 1 -x 47',freq_hz,sample_rate_hz);
%inst=sprintf('hackrf_transfer -c 127 -f %d -s %d -p 1 -a 1 -x 47',freq_hz,sample_rate_hz);
inst
system(inst);
