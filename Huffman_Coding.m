clear

FILE    = fopen('text.txt', 'r');
Text    = fread(FILE);                  % Read .txt file
N_Text  = length(Text);                 % Length of text

[Letters Index I]   = unique(Text);

N_Letters   = length(Letters);          % Amount of unique characters
N_Unique    = zeros(1,N_Letters);       % Count of each unique character



for i = 1:N_Letters
    
    for j = 1:N_Text
        
        if Letters(i)==Text(j)
        
            N_Unique(i) = N_Unique(i) + 1;
        
        end
        
    end
    
end 


% Sort highest to lowest letter frequency --------------------------------

Temp_Letters    = Letters;

[N_Unique Index] = sort(N_Unique);

for i = 1:N_Letters
    
    Letters(i) = Temp_Letters(Index(i));
    
end

Letter_Freq   = [Letters, N_Unique']; % First row character, second freq.

Layers = log2(length(Letters));

if mod(Layers,1)>0
    
    Layers  = uint16(Layers) + 1;
    
end

Huff_Tree       = zeros(length(Letters),Layers);
Huff_Tree(:,1)  = Letter_Freq(:,2);


for i = 1:Layers
    
    
    




end

