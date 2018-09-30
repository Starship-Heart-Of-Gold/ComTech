clear 

%% == Programm variables =================================================

Bits                = 9;           % Size of the dictionary index
Dictionary_Length   = 2^Bits - 2^8; % With of symbol (10 bit) minus ASCII 
                                    % size

%% == Read text file =====================================================

FILE    = fopen('text.txt', 'r');
Text    = fread(FILE);
N_Text  = length(Text);

%% == Dictionary construction ============================================

%Dictionary              = {'ID', 'Characters'};
Dictionary(Dictionary_Length).ID           = 0;
Dictionary(Dictionary_Length).Characters   = 0;

for i = 1:length(Dictionary(:))
   
    Dictionary(i).ID           = 0;
    Dictionary(i).Characters   = 0;
    
end
                   
N_Dictionary    = length(Dictionary(:));
P_Dictionary    = 0;                  % Pointer of last entry in dictionary

Alredy_exists   = false;              % Does the data set already exist?
Add_Character   = 0;                  % Increase amount of character which 
                                      % should be read if an element
                                      % already exists in the dictionary                                      
Step_Back       = 0;


%% == Compression algorithm ==============================================

for i = 1:length(Text)-1
    
    if (i-Step_Back + Add_Character) > N_Text
        
        break
        
    end

    Current  = Text(i-Step_Back:i-Step_Back+Add_Character);
    Next     = Text(i+1);
   
    Output   = [Current' Next];
   
        for j = 1:P_Dictionary + 1
    
            if j>Dictionary_Length
            
                break
        
            end
             
            if length(Dictionary(j).Characters) == length(Output)
                
                if isequal(Dictionary(j).Characters, Output)

                    Alredy_exists = true;
                    Add_Character = Add_Character + 1;
                    Step_Back = 1;
                    break

                end
                
            end
            
            
            if Dictionary(j).ID == 0
                    
                Alredy_exists = false;
                Add_Character = 0;
                Step_Back = 0;
                breakx
                      
            end
            
        end
        
        
        
        if  ~Alredy_exists

            P_Dictionary = P_Dictionary + 1;
            Dictionary(P_Dictionary).ID        = 2^8 - 1 + P_Dictionary;
            Dictionary(P_Dictionary).Characters= Output;
            
        end
        
    if j>Dictionary_Length

        break

    end
    
end


%% == Compression percentage =============================================

Compressed_Txt  = 0;
Text_Length     = (length(Text)*8);

for i = 1:length(Dictionary(:))
    
    
   if Dictionary(i).Characters(:)~=0
   
       Compressed_Txt = Compressed_Txt + length(Dictionary(i).Characters(:)*9);
   
   else
       
       break
       
   end
end

Compression     = 100*(1 - Compressed_Txt/Text_Length);

disp(['A compression of ', num2str(Compression), '% has been achieved'])

%% == Conversion to bit stream ===========================================