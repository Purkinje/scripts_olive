% OUnoise.m
function gen_synaptic_noise()
% Present 2 or 3 times for 3 seconds. 5 seeds 5 presentations.
% 5-10 pA current.
% with and without carbenoxel.
% over time align transients. 
% 400 pA/V

fs=50e3; %samplingrate
num_trials=50;
durstim=3;
tracedur=10;
set(0, 'defaultaxescolororder', linspecer(15))

mu = 0;
sig = 15;
thetas = 0:num_trials; % was [0:10]
delta = 1/fs; %1/dt
simtime = durstim*fs;


curr_noise=zeros(length(thetas),simtime);

curr_noise(1) = mu; n =0;

if exist('randomseed')
	randomseed = randomseed + 1
else
	randomseed = 0
end

for th = thetas
	n = n+1;
	%rng(randomseed)
	for t = 1:simtime
	
	curr_noise(n,t+1) = curr_noise(n,t) + th*(mu-curr_noise(n,t))*delta + sig*sqrt(delta)*randn;
	end
	
end
% figure
% plot(curr_noise')
% legend(num2str(thetas'))
% title('ohrstein uhlenbeck process with 0 mean and 1 std')


% generate three vectors to write out with random insertion of synaptic
% noise to be added to CMD 



outputmatrix = zeros(tracedur*fs, num_trials); %10 seconds per trial

%generate random integer falling within range of matrix

rannum = randi(tracedur*fs-(durstim*fs),1) %do not fall in range 3 seconds towards end otherwise the noise is clipped.

size(curr_noise)

size(outputmatrix)


for i=1:num_trials
    
    outputmatrix((rannum:rannum+(durstim*fs)),i) = curr_noise(i,:);

end



% the time axis
t=0:1/fs:((10)-(1/fs));



strf=['~/Desktop/stims/synapticnoise.atf'];
fid = fopen(char(strf),'w');
% 

stra=['%s\t%s\n%s\t%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\n%s\t%s\n'];

fprintf(fid,stra,'ATF','1.0','8',num2str(num_trials+1),'"AcquisitionMode=Episodic Stimulation"', '"Comment= Created by tycho.hoogland@gmail.com"',  '"YTop=5"',  '"YBottom=0"',  '"SyncTimeUnits=10"',  '"SweepStartTimesMS=0.000"',  '"SignalsExported=OUT 3"',  '"Signals= "',	'"V"');

%create string to name columns
strb='%s\t';
strb=repmat(strb,1,num_trials);
strb=[strb '%s\n'];

%column names
columnnames = [ '' '"OUT 3 (V)"'  '' ];
columnnames = repmat(columnnames,1, num_trials);
columnnames = ['"Time (s)"' columnnames];

%print it to the atf file
fprintf(fid, strb, columnnames);
fprintf(fid,'\n');

%create fprintf string for columns
strc='%.8f\t';
strc=repmat(strc,1,num_trials);
strc=[strc '%.8f\n'];

%print data to columns
fprintf(fid,strc,[t; outputmatrix']);
fclose(fid);
