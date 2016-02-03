function combine_abfimage_figures()

% load files with certain extension
dir = uigetdir;
% cd ..
[p f] = subdir(dir); %extract subdirectories (p) and filenames (f) therein

subfon=0;


for ii=1:length(f)

    cd(p{ii}); %make sure to be in right subdir
    sf = f{ii};

    
    for jj=1:length(sf)
    
%     try
    strout=strcat( num2str(ii), '/ ', num2str(length(f)) );
    disp(strout);

    fullfilename = sf{jj};
   
 
        
        if(strfind(fullfilename,'fig'))
     
        open(fullfilename); %open the figure
        
        h=findobj(gcf); % find object handles of figure
        
        d_in = pwd;
        cd ..
        print('-dpsc2','epsp_ipsp','-append','-f1');
        
        drawnow();
        close;
        cd(d_in)
        end

        

    
    

    end
end
%write out