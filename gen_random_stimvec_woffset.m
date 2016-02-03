function  gen_random_stimvec_woffset(vec_dur,stim_dur, num_stims, amplitude, fs, num_fs)
% /// function gen_random_stimvec(numstim, duration, fs) 
% /// Generates ATF files to use in episodic stimulation mode
% ///
% /// INPUT: 
% /// vec_dur = duration of stimulus vector (s)
% /// stim_dur = duration of stimulus (s)
% /// num_stims = number of stimuli (#)
% /// amplitude = amplitude of TTL pulse for stimulus (V)
% /// fs = acquisition sampling frequency (Hz)
% /// num_fs = number of stim vectors to generate (#)
% ///
% ///
% /// Example:  Generate an ATF file with 5 sweeps of 20s duration and 10 random stimuli with TTL amplitude off 5V
% ///           
% /// output: randomized stimulus vector
% /// tycho.hoogland@gmail.com / Dec. 2015


% the time axis
t=0:1/fs:(vec_dur-(1/fs));

q=0;
for i=1:num_fs

   
 disp(['... ' num2str(i) ' out of ' num2str(num_fs)]);
%draw random numbers that fall within stimulus vector range    
%rannums = round(rand(1, num_stims)*fs*vec_dur); 
stimvec = zeros(1, vec_dur*fs);

% modified this piece of code from stackexchange: http://bit.ly/1LiDc3H
len_interval=vec_dur*fs;   %length of interval
min_dist=0.1*fs;           %minimum distance in this case 500 ms
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

size(stimvecs)
% figure;
for i=1:size(stimvecs,2)
%     plot(stimvecs(:,i))
%     pause
    idx(i)=find(diff(stimvecs(:,i))>0); %not accounting yet for multiple stims within trial
    size(idx)
end

[idx']

time_interval_second_stim = 0.01; % 10 ms steps for second interval
interval_twostims = fs*0.01;
pre_stim1 = -0.1*fs; % 200 ms pre
post_stim1 = 0.2*fs; % 200 ms post
stimdur2 = (20/1000)*fs; % stimulus duration 2 in samples


timepoints = pre_stim1:interval_twostims:post_stim1;

offsetstims=idx-timepoints;

stimvecs_offsets=zeros(size(stimvecs));

for i=1:size(stimvecs_offsets,2)
   
    stimvecs_offsets(offsetstims(i)+stimdur2,i)=amplitude;
    
end

strf=['~/Desktop/stims/datest.atf'];
fid = fopen(char(strf),'w');
% 

stra=['%s\t%s\n%s\t%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\t%s\n'];

fprintf(fid,stra,'ATF','1.0','8',num2str(num_fs+1),'"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"',  '"YTop=5"',  '"YBottom=0"',  '"SyncTimeUnits=10"',  '"SweepStartTimesMS=0.000"',  '"SignalsExported=OUT 3"',  '"Signals= "',	'"V"');

%create string to name columns
strb='%s\t';
strb=repmat(strb,1,num_fs);
strb=[strb '%s\n'];

%column names
columnnames = [ '' '"OUT 3 (V)"'  '' ];
columnnames = repmat(columnnames,1, num_fs);
columnnames = ['"Time (s)"' columnnames];

%print it to the atf file
fprintf(fid, strb, columnnames);
fprintf(fid,'\n');

%create fprintf string for columns
strc='%.8f\t';
strc=repmat(strc,1,num_fs);
strc=[strc '%.8f\n'];

%print data to columns
fprintf(fid,strc,[t; stimvecs']);
fclose(fid);


% write out of second file

strf=['~/Desktop/stims/datest2.atf'];
fid = fopen(char(strf),'w');
% 

stra=['%s\t%s\n%s\t%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\t%s\n'];

fprintf(fid,stra,'ATF','1.0','8',num2str(num_fs+1),'"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"',  '"YTop=5"',  '"YBottom=0"',  '"SyncTimeUnits=10"',  '"SweepStartTimesMS=0.000"',  '"SignalsExported=OUT 3"',  '"Signals= "',	'"V"');

%create string to name columns
strb='%s\t';
strb=repmat(strb,1,num_fs);
strb=[strb '%s\n'];

%column names
columnnames = [ '' '"OUT 3 (V)"'  '' ];
columnnames = repmat(columnnames,1, num_fs);
columnnames = ['"Time (s)"' columnnames];

%print it to the atf file
fprintf(fid, strb, columnnames);
fprintf(fid,'\n');

%create fprintf string for columns
strc='%.8f\t';
strc=repmat(strc,1,num_fs);
strc=[strc '%.8f\n'];

%print data to columns
fprintf(fid,strc,[t; stimvecs_offsets']);
fclose(fid);
