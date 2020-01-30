clear all;
clc

%Voýce Record
kayit = audiorecorder(8000,8,1);
record(kayit,5);
dijital = getaudiodata(kayit, 'uint8');
audiowrite('LabProje.wav',dijital,8000,'BitsPerSample',8);



%Read audio file
[dijital, fs] = audioread('LabProje.wav','native');
bidiji = de2bi(dijital, 8);

%BPSK Modulation
n = 15; k=8;
gpol = cyclpoly(n,k);
parmat = cyclgen(n,gpol);
trt = syndtable(parmat);
doublediji = double(bidiji);
encData = encode(doublediji,n,k,'cyclic/binary',gpol);
bpskModulator = comm.BPSKModulator;
bpskModulator.PhaseOffset = pi/16;
encVector = encData(:);
modData = bpskModulator(encVector);

%Noise Application
awgNoise = awgn(modData, 5);

%Demodulation
bpskDemodulator = comm.BPSKDemodulator;
Demod = bpskDemodulator(awgNoise);
demodMat = reshape(Demod, [40000,n]);
decData = decode(demodMat,n,k,'cyclic/binary',gpol,trt);

%Gathering the audio back
gonderilenses = bi2de(decData);
gonderilenses = gonderilenses -128;
orjinalses=double(dijital);
orjinalses = orjinalses - 128;

%Error rate
[hata, oran] = biterr(doublediji,decData);

%Plotting Audios
subplot(2,1,1);
plot(orjinalses);
subplot(2,1,2);
plot(gonderilenses)

%RMSE Calculatýon
RMSE = sqrt(mean((orjinalses - gonderilenses).^2));

