#include<EEPROM.h>
int segmentPins[] ={3,2,19,16,18,4,5,17}; //输出到数码管的8个引脚，abcdefg.
int displayPins[] ={6,15,7,14}; //控制哪一个数码管亮的引脚，1234
int times[]={
    5,10,15,20,30,
    45,100,130,200,230,
    300,400,500,600,700,
    800,900,1000, 1500, 2000,
    3000}; //设定的不同的时间间隔
int numTimes=20; //总共的时间间隔数
byte selectedTimeIndex;
int timerMinute;
int timerSecond;
//buzzer是蜂鸣器的意思
int buzzerPin=11; //Arduino第11脚，用于控制蜂鸣器，在共阴时置HIGH会叫
int aPin=8; //Arduino第8脚，连接旋转译码器输入
int bPin=10; //Arduino第10脚，连接旋转译码器输入
int buttonPin=9; //Arduino第9脚，连接旋转译码器输入
boolean stopped = true;
byte digits[10][8] ={
    //a b c d e f g ．
    {1,1,1,1,1,1,0,0},//0
    {0,1,1,0,0,0,0,0},//1
    {1,1,0,1,1,0,1,0},//2
    {1,1,1,1,0,0,1,0},//3
    {0,1,1,0,0,1,1,0},//4
    {1,0,1,1,0,1,1,0},//5
    {1,0,1,1,1,1,1,0},//6
    {1,1,1,0,0,0,0,0},//7
    {1,1,1,1,1,1,1,0},//8
    {1,1,1,1,0,1,1,0}//9
};


void setup() //Arduino初始设置
{
    //设定输入输出
    for(int i=0;i<8;i++)
    {
        pinMode(segmentPins[i],OUTPUT); //设定为输出脚
    }
    for(int i=0;i<4;i++)
    {
        pinMode(displayPins[i],OUTPUT);
    }
    pinMode(buzzerPin,OUTPUT);
    pinMode(buttonPin,INPUT);
    pinMode(aPin,INPUT_PULLUP);//aPIN，bPIN用INPUT_PULLUP
    pinMode(bPin,INPUT_PULLUP);
    //初始时间的设定
    selectedTimeIndex=EEPROM.read(0);
    timerMinute=times[selectedTimeIndex]/100;
    timerSecond=times[selectedTimeIndex]%100;
}

void loop() //循环执行，Arduino的主功能区
{
    
    if(!digitalRead(buttonPin)) //digitalRead 读取引脚的高低电平值，返回值为0或1
    //当buttonPin，即第9脚输入为LOW时执行，即此时旋倒计时被开启
    {
        stopped = !stopped; //倒计时工作 False
        digitalWrite(buzzerPin,LOW); //第11脚置LOW表示不要叫，即按按钮让它不叫
        while(!digitalRead(buttonPin)){} //当第9脚为LOW时停住，当HIGH时再继续
        EEPROM.write(0,selectedTimeIndex); //记录目前选择的时间
    }
    
    updateDisplay(); //不断循环执行
}

void updateDisplay() //mmss
{
    int minsecs = timerMinute*100+timerSecond;//构成mmss四位数
    int v = minsecs;
    for(int i=0;i<4;i++)
    //依次亮四个数码管
    {
        int digit=v%10; //取最后1位数字
        setDigit(i); //设定哪一个数码管亮
        setSegments(digit); //设定亮的字形
        v=v/10;
        process();//亮完一个处理一下
    }
    setDigit(5);//把所有数码管都熄灭
}

void process()
{
    for(int i=0;i<100; i++)//在闪烁和模糊之间调整这个数字
    {
        int change=getEncoderTurn(); //-1，0，1，可能是表示顺逆时针
        if(stopped) //stopped为True表示没被开启，在改时间
        {
            changeSetTime(change);//改变设定时间
        }
        else
        {
            updateCountingTime();//没在改时间，继续更新倒计时
        }
    }
    if(timerMinute == 0 && timerSecond == 0)
    {
        digitalWrite(buzzerPin,HIGH); //第11脚置HIGH表示倒计时结束了，开始叫
    }
}

void changeSetTime(int change)
//改变设定时间
{
    selectedTimeIndex+=change;//-1，0，+1，表示在时间数组中取值的移动
    if(selectedTimeIndex<0)
    {
        selectedTimeIndex=numTimes;
    }
    else if(selectedTimeIndex>numTimes)
    {
        selectedTimeIndex = 0;
    }
    //时间重新设定
    timerMinute=times[selectedTimeIndex]/100;
    timerSecond=times[selectedTimeIndex]%100;
}

void updateCountingTime()
//继续更新倒计时
{
    static unsigned long lastMillis;//记录上一次更新的时间
    unsigned long m=millis();
    //millis函数可以用来获取Arduino开机后运行的时间长度，该时间长度单位是毫秒
    if(m>(lastMillis+1000) && (timerSecond>0 || timerMinute>0))
    //亮了1s且还有倒计时的话
    {
        //每次倒计时减少都小叫10ms提醒一下
        digitalWrite(buzzerPin,HIGH);
        delay(10); //延迟10ms
        digitalWrite(buzzerPin,LOW);
        //倒计时的减少
        if(timerSecond==0)
        {
            timerSecond=59;
            timerMinute--;
        }
        else
        {
            timerSecond--;
        }
        lastMillis = m;//update上一次更新的时间
    }
}

void setDigit(int digit)
//设置控制哪个数码管亮的引脚(displayPins)的电平，若digit为5就都不亮
{
    for(int i=0;i<4;i++)
    {
        digitalWrite(displayPins[i],(digit==i)); 
        //*不等于编号digit的都置1，因为1是不亮
        //here changed 改成不等于都置0，因为用的是共阴，0才是不亮
    }
}

void setSegments(int n)
//设置亮哪个数码的引脚(segmentPins)的电平，n表示亮成哪个数字
{
    for(int i=0;i<8; i++)
    {
        digitalWrite(segmentPins[i],digits[n][i]); 
        //*here changed 因为共阴所以不用取反
    }
}

int getEncoderTurn()
// return -1，0，or +1, 顺时针-1 逆时针+1
{
    static int oldA=LOW;
    static int oldB=LOW;
    //静态变量，用于记录A B状态，初始为LOW
    int result = 0;
    int newA=digitalRead(aPin);
    int newB=digitalRead(bPin);
    if (newA != oldA || newB != oldB)//旋转编码器转动
    {   
        if(oldA==LOW && newA==HIGH) result=-(oldB*2-1);
    }
    //更新oldA oldB
    oldA = newA;
    oldB = newB;
    return result;
}