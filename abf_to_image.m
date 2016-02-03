function abf_to_image(filename, lowc, highc)


[data,samplinginterval_us header] = abfload(filename);

size(data)


samplingrate = 1/(samplinginterval_us*1e-6);

sz=size(data);
numtrials=sz(3);
analogchan = sz(2);

datachan = data(:,2,:); %using channel ...
datachan = reshape(datachan,sz(1),sz(3))'; %data channel
chanstim1 = data(:,5,:);
chanstim1 = reshape(chanstim1,sz(1),sz(3))'; %stored first stim chan
chanstim2 = data(:,6,:);
chanstim2 = reshape(chanstim2,sz(1),sz(3))'; %stored second stim chan 

cmap = gen_divergent_colormap;


%datachan = remove_voltage_artifact(datachan,0.01);

x=0:(1/samplingrate):(size(datachan,2)-1)*(1/samplingrate);

disp('size x')
size(x)
disp('size chanstim1') 
size(chanstim1)
disp('size datachan')
size(datachan)
%fh=figure;
cla;
colormap(cmap);
% mesh(datachan,'FaceColor','texturemap','EdgeColor','none')
% zlim([-64.51416159825389 -51.87988397210577]) 
% pause;
imagesc(x,[1:numtrials],datachan);



colormap(cmap);
if(lowc==0 && highc==0)
     cmapax = caxis;
            caxis manual;
            
            %caxis([cmapax(1) cmapax(2)]);
       
            caxis([ -65 -40]);

            %caxis([ -64.51416159825389 -51.87988397210577]);
else
    
    [lowc highc]
    caxis([lowc highc]);
end

fig_size(gcf,800,240);
set(gca,'TickDir','out');
box off;
title(strrep(filename,'.abf',''))
xlabel('time (s)');
ylabel('trial #');
colorbar;
hold on;

plot(x,chanstim1,'r');
plot(x,chanstim2,'b');
savefig(strrep(filename,'.abf','.fig'));
drawnow();

%plotallchanges(datachan);

clear data;
clear cmap;
clear datachan;
clear chanstim1;
clear chanstim2;
%close(fh);