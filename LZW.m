clear 

FILE    = fopen('text.txt', 'r');
Text    = fread(FILE);
N_Text  = length(Text);

%Dictionary              = {'ID', 'Characters'};
Dictionary(255).ID           = 0;
Dictionary(255).Characters   = 0;
                   
N_Dictionary    = length(Dictionary.ID);
P_Dictionary    = 1;                  % Pointer of last entry in dictionary

for i = 1:length(Text)-1
  
   Current  = Text(i);
   Next     = Text(i+1);
   
   Output   = Current;
   
        for j = 1:P_Dictionary
    
            if length(Dictionary(j).Characters)==length(Output)
                if Dictionary(j).Characters~=char(Output)
                
                    Dictionary(j).ID        = 255 + 1;
                    Dictionary(j).Characters= char(Output);
                
                    P_Dictionary = P_Dictionary + 1;
                
                end
            end
            
        end
    
end