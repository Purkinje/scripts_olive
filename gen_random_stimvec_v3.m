function  gen_random_stimvec_v3(vec_dur,stim_dur, num_stims, amplitude, fs, num_fs, figf)
% /// function gen_random_stimvec(numstim, duration, fs) 
% /// inputs: num_stims = number of stimuli, stim_dur = duration of stimulus (s), vec_dur = duration of stimulus vector (s)
% /// seconds, amplitude = amplitude of TTL pulse for stimulus in V, fs = acquisition sampling frequency in Hz, num_fs 
% /// num_fs = number of stim vectors to generate
% /// output: randomized stimulus vector
% /// tycho.hoogland@gmail.com / October 2015

%generate new seed per Matlab session
%rng('shuffle');
if(figf==1)
    figure;
    hold on;
    scz=get(0,'ScreenSize');
    set(gcf,'Position', [scz(2)/2 scz(3)/2 1000 100]);
    axis off;
    
    drawnow();
end

x=0:1/fs:(vec_dur-(1/fs));

q=0;
for i=1:num_fs

 disp(['... ' num2str(i) ' out of ' num2str(num_fs)]);
%draw random numbers that fall within stimulus vector range    
rannums = round(rand(1, num_stims)*fs*vec_dur); 
stimvec = zeros(1, vec_dur*fs);

% modified this piece of code from stackexchange: http://bit.ly/1LiDc3H
len_interval=vec_dur*fs;   %length of interval
min_dist=0.5*fs;           %minimum distance in this case 500 ms
points_space=len_interval-(num_stims-1)*min_dist;    %excess space for points
%generate N+1 random values; 
Ro=rand(num_stims+1,1);     %random vector
%normalize so that the extra space is consumed
% extra value is the amount of extra space "unused"
Rn=points_space*Ro(1:num_stims)/sum(Ro);
%normalize spacing of points
S=min_dist*ones(num_stims,1)+Rn; 
%location of points, adjusted to "start" at 0
rannums=round(cumsum(S)-1)';
interval = stim_dur*fs;
numstims=length(rannums);

try
idx=find(rannums<=0);

rannums(idx)=[];
numstims=length(rannums);
catch
end

try
idx=find(rannums>=(vec_dur*fs));

rannums(idx)=[];
numstims=length(rannums);
catch
end

for k = 1:numstims
stimvec(1,rannums(1,k):rannums(1,k)+interval)=amplitude;
end

% 
if(figf)
    
    plot(x,stimvec,'Color',[rand(1,1) rand(1,1) rand(1,1)]); 
     if(mod(i,3)==0)
        unplot(3*num_stims); 
     end
    drawnow();
    
end
% pause;
% str=['~/Desktop/stims/stim_',num2str(i),'.txt'];
% 
% fid0=fopen(char(str),'w');
% fprintf(fid0,'%f\n',stimvec);
% fclose(fid0);

% figure; plot(x,stimvec)
% 
% 
% strz=['~/Desktop/stims/stim_z','.txt'];
% fidz=fopen(char(strz),'w');
% fprintf(fidz,'%.5f\t%.5f',x',stimvec');
% fclose(fidz);
%[x' stimvec']


if(q==0)
    %xs=x;
    stimvecs=stimvec';
    q=1;
else
    %xs=[xs;x];
    stimvecs=[stimvecs,stimvec'];
end

% need to exclude signals 1/64th of total samples in ATF file at start and end for holding potential
end

stimvecs(1:100,:)

% str2=['~/Desktop/stims/stim_',num2str(i),'.atf'];
str2=['~/Desktop/stims/ManySweeps.atf'];
fid = fopen(char(str2),'w');
% 
fprintf(fid,'%s\t%s\n %s\t%s\n %s\n  %s\n %s\n %s\n %s\n %s\n %s\n %s\t%s\n %s\t%s\t%s\t%s\t%s\t%s\n', 'ATF',	'1.0','9', '6     ', '"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"', '"YTop=5"',  '"YBottom=0"', '"SyncTimeUnits=10"', '"SweepStartTimesMS=0.000"', '"SignalsExported=OUT 3"', '"Signals= "',	'"V"', '"Time (s)"','"OUT 3 (V)"','"OUT 3 (V)"','"OUT 3 (V)"','"OUT 3 (V)"','"OUT 3 (V)"');
% %fprintf(fid,'%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n', 'ATF	1.0','8 5', '"AcquisitionMode=Episodic Stimulation"',  '"Comment="', '"YTop=0,0"',  '"YBottom=0,0"', '"SyncTimeUnits=10"', '"SweepStartTimesMS=0.000"', '"SignalsExported=IN 1"', '"Signals="	"IN 1"', '"Time (s)" "Trace #1 (mV)"');
fprintf(fid,'%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t%.8f\t\n',[x; stimvecs']);
fclose(fid);

% figure; plot(x,stimvec(:,1));