void setup() {
    size(100, 100);
    int start = millis();
    parseFile();
    int end = millis();
    println("execution-time:");
    println(end - start);
    exit();
}


ArrayList<Num> vals = new ArrayList<Num>();

void parseFile() {
    BufferedReader reader = createReader("test.txt");
    String line = null;
    int ind = 0;
    try {
        while ((line = reader.readLine()) != null && line.length()>0) {
            Num n = new Num();
            int depth = 0;

            for(int i = 0; i < line.length();i++){
                if(line.charAt(i) == '['){
                    depth++;
                } else if(line.charAt(i) == ']'){
                    depth--;
                }else if(line.charAt(i) != ','){
                    n.append(line.charAt(i) - '0',depth);
                }
            }
            vals.add(n);
        }
        reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    }

    Num tot = vals.get(0);

    for(int i = 1; i < vals.size(); i++){
        tot = new Num(tot,vals.get(i));
    }

    println(tot.mult());

    int maxVal = 0;

    for(int i = 0; i < vals.size(); i++){
        for(int j = 0; j< vals.size(); j++){
            if(i == j) break;
            Num n = new Num(vals.get(i),vals.get(j));
            int val = n.mult();
            if(val > maxVal) {
                maxVal = val;
            }
        }
    }
    println(maxVal);
}

class Num {

    IntList nums = new IntList();
    IntList depths = new IntList();

    Num(){}

    Num(Num n1, Num n2){
        depths.append(n1.depths);
        depths.append(n2.depths);
        nums.append(n1.nums);
        nums.append(n2.nums);
        for(int i = 0; i < depths.size(); i++){
            depths.increment(i);
        }
        boolean cont = true;
        while(cont){
            cont = false;
            for(int i = 0; i < depths.size(); i++){
                if(depths.get(i) >= 5){
                    cont = true;
                    depths.sub(i,1);
                    depths.remove(i+1);
                    if(i-1 >= 0) nums.add(i-1,nums.get(i));
                    if(i+2 < nums.size()) nums.add(i+2,nums.get(i+1));
                    nums.set(i,0);
                    nums.remove(i+1);
                    break;
                }
            }
            for(int i = 0; i < nums.size() && !cont; i++){
                if(nums.get(i) >= 10){
                    cont = true;
                    int n = nums.get(i);
                    int d = depths.get(i);
                    int lower = floor(n/2.0);
                    int upper = ceil(n/2.0);
                    nums.remove(i);
                    depths.remove(i);
                    nums.insert(i,upper);
                    nums.insert(i,lower);
                    depths.insert(i,d+1);
                    depths.insert(i,d+1);
                    break;
                }
            }
        }
    }

    void append(int val, int d){
        nums.append(val);
        depths.append(d);
    }

    int mult(){
        while(nums.size() > 1){
            for(int i = 0; i < nums.size()-1; i++){
                if(depths.get(i) == depths.get(i+1)){
                    int val = nums.get(i) * 3 + nums.get(i+1) * 2;
                    depths.remove(i+1);
                    nums.remove(i+1);
                    depths.sub(i,1);
                    nums.set(i,val);
                    break;
                }
            }
        }
        return nums.get(0);
    }

    void print(){
        println(nums);
    }
}
