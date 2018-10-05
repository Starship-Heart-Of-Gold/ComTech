clear 

%% == Programm variables =================================================

Bits                = 9;           % Size of the dictionary index
Dictionary_Length   = 2^Bits - 2^8; % With of symbol (10 bit) minus ASCII 
                                    % size

%% == Read text file =====================================================

FILE    = fopen('text.txt', 'r');
Tx_Text    = fread(FILE);
N_Text  = length(Tx_Text);

%% == Dictionary construction ============================================

Dictionary(Dictionary_Length).ID           = 0;
Dictionary(Dictionary_Length).Characters   = 0;

for i = 1:length(Dictionary(:))
   
    Dictionary(i).ID           = 0;
    Dictionary(i).Characters   = 0;
    
end
                   
N_Dictionary    = length(Dictionary(:));
P_Dictionary    = 0;                % Pointer of last entry in dictionary

Output          = zeros(N_Dictionary,1);
P_Output        = 1;                % Pointer of last entry in output

Alredy_exists   = false;            % Does the data set already exist?
Add_Character   = 0;                % Increase amount of character which 
                                    % should be read if an element
                                    % already exists in the dictionary                                      
Step_Back       = 0;                % Helps to read more characters from text



%% == Compression ========================================================

disp('Build dictionary:')
fprintf('\n')

for i = 1:N_Text
    
    if (i-Step_Back+Add_Character+1) > N_Text
        
        Output(P_Output) = Tx_Text(end);
        break
        
    end

    Current  = Tx_Text(i-Step_Back:i-Step_Back+Add_Character);
    Next     = Tx_Text(i-Step_Back+Add_Character+1);
   
    New_Char   = [Current' Next];
   
        for j = 1:P_Dictionary + 1
    
            if j>Dictionary_Length
            
                break
        
            end
             
            if length(Dictionary(j).Characters) == length(New_Char)
                
                if isequal(Dictionary(j).Characters, New_Char)

                    Alredy_exists   = true;
                    Add_Character   = Add_Character + 1;
                    Step_Back       = 1;
                    Output(P_Output)= Dictionary(j).ID;
                    P_Output        = P_Output + 1;
                    break

                end
                
            end
            
            
            if Dictionary(j).ID == 0
                    
                Alredy_exists = false;
                Add_Character = 0;
                Step_Back = 0;
                break
                      
            end
            
        end
        
            
        if  ~Alredy_exists

            P_Dictionary                        = P_Dictionary + 1;
            Dictionary(P_Dictionary).ID         = 2^8 - 1 + P_Dictionary;
            Dictionary(P_Dictionary).Characters = New_Char;
            
            if length(Current) == 1
                Output(P_Output)= Current;
                P_Output        = P_Output + 1;
            end
            
            disp(char(New_Char))
            
        end   
        
end

fprintf('\n')
disp('Done')

%% == Compression percentage =============================================

Compressed_Txt  = 0;
Text_Length     = (length(Tx_Text)*8);

for i = 1:length(Output(:))
    
   if Output(i)~=0
   
       Compressed_Txt = Compressed_Txt + Bits;
   
   else
       
       break
       
   end
   
end

Compression     = 100*Compressed_Txt/Text_Length;

fprintf('\n')

disp(['The text has been compressed down to ', num2str(Compression), '%'])

fprintf('\n')

%% == Conversion to bit stream ===========================================

%   Message:
%   +------------+----------------------------------+
%   |   HEADER   |              PAYLOAD             |
%   +------------+----------------------------------+
%   
%   Header:                      
%   +---------------+-------------------+
%   | HEADER LENGTH |   PAYLOAD LENGTH  |
%   +---------------+-------------------+
%         4 bit             4 bit
%
%   Payload:                      
%   +-----------------+------------+-----------------+------------+----
%   | DICTIONARY WORD | PARITY BIT | DICTIONARY WORD | PARITY BIT | .....
%   +-----------------+------------+-----------------+------------+----
%         9 bit           1 bit           9 bit          1 bit


% HEADER
Tx_Header_Length    = dec2bin(8,4);
Tx_Payload_Length   = dec2bin(Bits,4);

Tx_Header           = [Tx_Header_Length Tx_Payload_Length];

% PAYLOAD
Tx_Payload  = dec2bin(Output(1:i-1));  % The i-1 gets taken from the for 
                                        % loop in section "Compression 
                                        % percentage"
Tx_Payload  = Tx_Payload(:)';


% MESSAGE
Tx_Message         = [Tx_Header Tx_Payload];

%% == Extract data from bit stream =======================================


% HEADER
Rx_Header_Length    = bin2dec(Tx_Message(1:4));
Rx_Payload_Length   = bin2dec(Tx_Message(4:Rx_Header_Length));


% PAYLOAD

Rx_Payload  = Tx_Message(Rx_Header_Length+1:end);

Payload     = reshape(Rx_Payload, ...
                      length(Rx_Payload)/Rx_Payload_Length, ...
                      Rx_Payload_Length);
                  
Payload     = bin2dec(Payload);

%% == Decompress =========================================================

N_Payload  = length(Payload);


Dictionary(Dictionary_Length).ID           = 0;
Dictionary(Dictionary_Length).Characters   = 0;

for i = 1:length(Dictionary(:))
   
    Dictionary(i).ID           = 0;
    Dictionary(i).Characters   = 0;
    
end
                   
N_Dictionary    = length(Dictionary(:));
P_Dictionary    = 0;                % Pointer of last entry in dictionary

Output          = zeros(N_Dictionary,1);
P_Output        = 1;                % Pointer of last entry in output

Alredy_exists   = false;            % Does the data set already exist?
Add_Character   = 0;                % Increase amount of character which 
                                    % should be read if an element
                                    % already exists in the dictionary                                      
Step_Back       = 0;                % Helps to read more characters from text

fprintf('\n')

for i = 1:N_Payload
    
    if (i-Step_Back+Add_Character+1) > N_Payload
        
        Output(P_Output) = Payload(end);
        break
        
    end

    Current  = Payload(i-Step_Back:i-Step_Back+Add_Character);
    Next     = Payload(i-Step_Back+Add_Character+1);
   
    New_Char   = [Current' Next];
   
        for j = 1:P_Dictionary + 1
    
            if j>Dictionary_Length
            
                break
        
            end
             
            if length(Dictionary(j).Characters) == length(New_Char)
                
                if isequal(Dictionary(j).Characters, New_Char)

                    Alredy_exists   = true;
                    Add_Character   = Add_Character + 1;
                    Step_Back       = 1;
                    Output(P_Output)= Dictionary(j).ID;
                    P_Output        = P_Output + 1;
                    break

                end
                
            end
            
            
            if Dictionary(j).ID == 0
                    
                Alredy_exists = false;
                Add_Character = 0;
                Step_Back = 0;
                break
                      
            end
            
        end
        
            
        if  ~Alredy_exists

            P_Dictionary                        = P_Dictionary + 1;
            Dictionary(P_Dictionary).ID         = 2^8 - 1 + P_Dictionary;
            Dictionary(P_Dictionary).Characters = New_Char;
            
            if length(Current) == 1
                Output(P_Output)= Current;
                P_Output        = P_Output + 1;
            end
            
           
            
        end   
        
end

Rx_Text = 0;
Shift = 0;

for i = 1:length(Output)
    
    if Output(i) == 0
                
        Rx_Text = [Rx_Text Output(i)];
        break
        
    end
    
    if Output(i)>255
        
        for j = 1:N_Dictionary
            
            if Output(i)==Dictionary(j).ID
            
                Rx_Text = [Rx_Text Dictionary(j).Characters];
            
            elseif Output(j) == 0
                
                break
                
            end
            
        end
        
    else
       
        Rx_Text = [Rx_Text Output(i)];

        
    end
    

    
end 

Rx_Text = Rx_Text(2:end-1)';    % The text contains one zero at the 
                                % beginning and one zero at the end for 
                                % some reason and they have to be excluded

if isequal(Tx_Text, Rx_Text)
    
    disp('Decompression was successfull!')
    disp(['Tx_Text: ', char(Tx_Text)])
    disp(['Rx_Text: ', char(Rx_Text)'])
    
else
    
    disp('Decompression was unsuccessfull!')
    disp(['Tx_Text: ', char(Tx_Text)'])
    disp(['Rx_Text: ', char(Rx_Text)])
    
end