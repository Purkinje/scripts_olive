function  genRandStimVec(vec_dur,stim_dur, num_stims, amplitude, fs, num_sweeps)
% /// function genRandStimVec(vec_dur,stim_dur, num_stims, amplitude, fs, num_sweeps)
% /// ...Generates ATF files to use in episodic stimulation mode...
% ///
% /// INPUT: 
% /// vec_dur = duration of stimulus vector (s)
% /// stim_dur = duration of stimulus (s)
% /// num_stims = number of stimuli
% /// amplitude = amplitude of TTL pulse for stimulus in V
% /// fs = acquisition sampling frequency in Hz
% /// num_sweeps = number of stim vectors to generate
% ///
% ///
% /// Example:  Generate an ATF file with 5 sweeps of 20s duration and 10 random stimuli (pulse width 20 ms) with TTL amplitude off 5V
% ///           gen_random_stimvec(20,20e-3,10,5,50e3,5)
% ///           sampling rate 50 kHz, stim duration 20 ms, 10 stimuli within 20 seconds for 5 sweeps, 5V output. 
% ///           note that due to edge conditions one stimulus may fall off and this is not fixed currently
% /// tycho.hoogland@gmail.com / October 2015


% the time axis
t=0:1/fs:(vec_dur-(1/fs));

q=0;

rannums_all = zeros(num_sweeps, num_stims);

for i=1:num_sweeps

   
 disp(['... ' num2str(i) ' out of ' num2str(num_sweeps)]);
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

rannums_all(i,:) = rannums;

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

strf=['~/Desktop/stims/datest.atf'];
fid = fopen(char(strf),'w');
% 

stra=['%s\t%s\n%s\t%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\t%s\n'];

fprintf(fid,stra,'ATF','1.0','8',num2str(num_sweeps+1),'"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"',  '"YTop=5"',  '"YBottom=0"',  '"SyncTimeUnits=10"',  '"SweepStartTimesMS=0.000"',  '"SignalsExported=OUT 3"',  '"Signals= "',	'"V"');

%create string to name columns
strb='%s\t';
strb=repmat(strb,1,num_sweeps);
strb=[strb '%s\n'];

%the text that names the columns
columnnames = [ '' '"OUT 3 (V)"'  '' ];
columnnames = repmat(columnnames,1, num_sweeps);
columnnames = ['"Time (s)"' columnnames];

%print it to the atf file
fprintf(fid, strb, columnnames);
fprintf(fid,'\n');

%create fprintf string for columns
strc='%.8f\t';
strc=repmat(strc,1,num_sweeps);
strc=[strc '%.8f\n'];

%print data to columns
fprintf(fid,strc,[t; stimvecs']);
fclose(fid);


%%% Generate another ATF file that has stims with an offset relative to the
%%% random stimuli


rannums_all

pre_stim=100e-3*fs;
post_stim=200e-3*fs;
dt = 10e-3*fs;
stim_dur2=20e-3*fs;

stimvecs2 = zeros(num_sweeps, vec_dur*fs);

for u=1:num_sweeps
    for v=1:num_stims
    
    %     sweep 1 = rannums_all(u,v)-prestim ...   
    if(u==1)
        stimvec2locs(u,v)   =(rannums_all(u,v)-pre_stim);
    else
        stimvec2locs(u,v)   =(rannums_all(u,v)-pre_stim)+(u-1)*dt;
    end
    
    tmp = stimvecs2(u,:);
    tmp(stimvec2locs(u,:):(stimvec2locs(u,:)+stim_dur2))=5;
    size(tmp)
    stimvecs2(u,:)=tmp;
    clear tmp;
    cla;
    plot(t,stimvecs2(u,:));
    hold on; plot(t,stimvecs(:,u),'r');
    pause;
    end
end

strf=['~/Desktop/stims/datest_shift.atf'];
fid = fopen(char(strf),'w');
% 

stra=['%s\t%s\n%s\t%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\t%s\n'];

fprintf(fid,stra,'ATF','1.0','8',num2str(num_sweeps+1),'"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"',  '"YTop=5"',  '"YBottom=0"',  '"SyncTimeUnits=10"',  '"SweepStartTimesMS=0.000"',  '"SignalsExported=OUT 3"',  '"Signals= "',	'"V"');

%create string to name columns
strb='%s\t';
strb=repmat(strb,1,num_sweeps);
strb=[strb '%s\n'];

%the text that names the columns
columnnames = [ '' '"OUT 3 (V)"'  '' ];
columnnames = repmat(columnnames,1, num_sweeps);
columnnames = ['"Time (s)"' columnnames];

%print it to the atf file
fprintf(fid, strb, columnnames);
fprintf(fid,'\n');

%create fprintf string for columns
strc='%.8f\t';
strc=repmat(strc,1,num_sweeps);
strc=[strc '%.8f\n'];

%print data to columns
fprintf(fid,strc,[t; stimvecs2]);
fclose(fid);
