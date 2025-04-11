v = VideoReader('E:/Projekt Lola Rennt_Dhana/Lola rennt Snip1.avi');
% frames = readFrame(v);

brightness = zeros(v.NumFrames,1);
for num_frame = 1:v.NumFrames
frames = read(v,num_frame);
gray_image = rgb2gray(frames);
brightness(num_frame,1) = mean(gray_image(:));
end



figure
plot(brightness)
k = 1:25:29925;
bn = arrayfun(@(x) mean(brightness(x:x+24)),k);
bn_conv = zscore(conv(spm_hrf(1),bn));

bcorr = [];
bloc = [];
bp = [];
for num_cm = 1:size(S,1)
xc = xcorr(S(num_cm,11:1207),bn_conv(1:1197),100,'normalized');
[bcorr(num_cm),bloc(num_cm)] = max(xc);
%     [m,loc] = max(xc)
%     [bcorr,bp] = corr(S(num_cm,11+loc-51:1207-101+loc),bn(1:end-50));
end
plot(bn)

%% load audio
[x,fs]=audioread('E:/Projekt Lola Rennt_Dhana/Lola rennt Snip1.avi');;
% 取x的一个通道
x=x(:,1);
% 将x从列向量转为行向量
x=x';
% max(x)
% 得到向量x的长度
Length=length(x);
%%-------------------语音分帧--------------------
% 每帧大小为M，当语音长度不是帧长的整数倍时：
% (1)若剩余长度大于等于帧长的二分之一，则补零至帧长
% (2)若剩余长度小于帧长的二分之一，则舍弃
% 用于计算声压级值的语音帧长分别为20ms、50ms、100ms、200ms以及500ms
framlen = 100;
% 每帧信号的离散点数
M=fs*framlen/1000;
% m为Length/M后得到的余数
m = mod(Length,M);
if m >= M/2 % 补零
    % 补零后的语音
    x = [x,zeros(1,M-m)];
    % 补零后的语音帧长
    Length = length(x);
else   % 即m < M/2，则将剩余的语音帧舍弃
    % l为Length/M后得到的商
    l = floor(Length/M);
    % 舍弃后的语音
    x = x(1,1:M*l);
    % 舍弃后的语音帧长
    Length = length(x);
end
% 最终的语音分帧总帧数
N = Length/M;
%%------------------------计算声压级-------------
s = zeros(1,N);
% N帧信号的声压级值存储在spl向量里
spl = zeros(1,N);
for k = 1:N
    % 读取第k帧信号
    s =x((k-1)*M + 1:k*M);
    % 计算第k帧信号的声压级值
    spl(1,k) = SPLCal(s,fs,framlen);
end
%%------------画图------
t = 1:Length;
SPL = zeros(1,Length);
for r = 1:N
    SPL(1,(r-1)*M+1:r*M) = spl(r);
end

k = 1:48000:48000*1197;
audio_spl = arrayfun(@(x) mean(SPL(x:x+47999)),k);
as_conv = zscore(conv(spm_hrf(1),audio_spl));



%% extract basic features
features = extractStimulusFeatures('E:/Projekt Lola Rennt_Dhana/Lola rennt Snip1.avi');
vid = VideoReader('E:/Projekt Lola Rennt_Dhana/Lola rennt Snip1.avi');
newVid = VideoWriter('Lola_rennt_10f.avi');
frameRate = 5;
newVid.FrameRate = frameRate;
frameToextrat = ceil(vid.FrameRate/frameRate);
open(newVid)

for frame = 1:vid.NumFrames
    thisFrrame = read(vid,frame);
    if frame ==1 || mod(frame-1, frameToextrat)==0
        fprintf('writting frame %d to file Lola_rennt_10f.avi\n',frame);
        writeVideo(newVid,thisFrrame);
    end
end
close(newVid)
features = extractStimulusFeatures('Lola_rennt_10f.avi','E:/Projekt Lola Rennt_Dhana/Lola rennt Snip1.avi');
%% sound
k = 1:5:5*1197;
sounde = arrayfun(@(x) mean(soundEnvelopeDown(x:x+4)),k);
sound_conv = zscore(conv(spm_hrf(1),sounde));

%% muflow
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muFlow(x:x+4)),k);
muflow_conv(:,1) = zscore(conv(spm_hrf(1),muflow));

%% SqTemporalContrast
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muSqTemporalContrast(x:x+4)),k);
muflow_conv(:,2) = zscore(conv(spm_hrf(1),muflow));

%% TemporalContrast
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muTemporalContrast(x:x+4)),k);
muflow_conv(:,3) = zscore(conv(spm_hrf(1),muflow));

%% luminance
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muLuminance(x:x+4)),k);
muflow_conv(:,4) = zscore(conv(spm_hrf(1),muflow));

%% sqluminance
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muSqLuminance(x:x+4)),k);
muflow_conv(:,5) = zscore(conv(spm_hrf(1),muflow));

%% localContrast
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muLocalContrast(x:x+4)),k);
muflow_conv(:,6) = zscore(conv(spm_hrf(1),muflow));

%% sqlocalContrast
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muSqLocalContrast(x:x+4)),k);
muflow_conv(:,7) = zscore(conv(spm_hrf(1),muflow));

%% sqFlow
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(muSqFlow(x:x+4)),k);
muflow_conv(:,8) = zscore(conv(spm_hrf(1),muflow));


%% diode
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(diode(x:x+4)),k);
muflow_conv(:,9) = zscore(conv(spm_hrf(1),muflow));

%% stdLocalContrast
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(stdLocalContrast(x:x+4)),k);
muflow_conv(:,10) = zscore(conv(spm_hrf(1),muflow));

%% sound
k = 1:5:5*1197;
muflow = arrayfun(@(x) mean(soundEnvelopeDown(x:x+4)),k);
muflow_conv(:,11) = zscore(conv(spm_hrf(1),muflow));


%% correlation between components and stimulis
allcorr = corr(S',muflow_conv(1:1210,:));
allcorr = abs(allcorr);

