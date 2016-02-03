function multi_abf_to_image()

dir = uigetdir;
% cd ..
[p f] = subdir(dir); %extract subdirectories (p) and filenames (f) therein
figure;
set(gcf,'color','w');
fig_size(gcf,800,491);

for ii=1:length(f)

    cd(p{ii}); %make sure to be in right subdir
    sf = f{ii};


    
    for jj=1:length(sf)
    
	fullfilename = sf{jj};
    strout=strcat( num2str(jj), '/ ', num2str(length(f)) );
    disp(strout);
        
     
    if(strfind(fullfilename,'.abf')) %is an abf file found then proceed
 
        
          
            abf_to_data_structure(char(fullfilename),1);
            
           close all;
      
         
    end
    
    end
    
    
    
end

