using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace BowlingScoreTest
{
    public partial class _Default : Page
    {

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        //*************************************************************************************************
        //FrameUpdate - 10/5/2016
        //Author - Steven Blomquist
        //
        //This webmethod is called every time a user enters a new pin count in the bowling app.  This code
        //takes in a string array that tracks the 21 throws in a game of bowling.  If a throw is skipped it 
        //is indicated as the value of '-1' in the array.  The last value can be blank depending if an extra
        //ball is used in the 10th
        //
        //Sample pinArray     - {10,-1,10,-1,5,2,6,0,5,5,10,-1,9,1,7,2,10,-1,6,1,}
        //Sample #2 (partial) - {10,-1,10,-1,5,2,6,0,5,,,,,,,,,,,,}
        //
        //The partial array seen above is valid as this code will totals and displays the bowling score realtime 
        //
        //Returns a comma deliminated string representing the bowling score per frame
        //Sample through 4 frames = 9,15,31,39
        //*************************************************************************************************
        [WebMethod]
        public static string FrameUpdate(string[] pinArray)
        {
            try
            {
                string ScorecardUpdate = string.Empty;
                int RunningTotalScore = 0;

                int ArrayPointer = 0;
                foreach(string pinCount in pinArray)
                {
                    if (pinCount != "-1" && pinCount != null)
                    {
                        //This ball counts.  It was not skipped after a strike and it is not blank(Not rolled yet.)
                        if (StartOfFrame(ArrayPointer))
                        {
                            string FrameScore = CalculateFrameScore(pinArray, ArrayPointer);

                            if (FrameScore != "-1")
                            {
                                RunningTotalScore += Convert.ToInt16(FrameScore);
                                ScorecardUpdate += RunningTotalScore.ToString() + ',';
                            }
                        }
                    }
                    else if(pinCount == null)
                    {
                        //End of entered Values
                        break;
                    }
                    ArrayPointer++;
                }

                string[] pins = pinArray;

                return ScorecardUpdate;
            }
            catch (Exception ex)
            {
                return "ERROR!!!!" + ex.Message + ": " + ex.InnerException.ToString();
            }
        }


        //*************************************************************************************************
        //CalculateFrameScore - 10/5/2016
        //Author - Steven Blomquist
        //
        //This method is called by FrameUpdate. This code does the calculations for the scoring.  This code
        //returns a single frame score.  Remember -1 means that this ball was skipped.  (After a strike)
        //
        //Sample ballsArray   - {10,-1,10,-1,5,2,6,0,5,5,10,-1,9,1,7,2,10,-1,6,1,}
        //Sample #2 (partial) - {10,-1,10,-1,5,2,6,0,5,,,,,,,,,,,,}
        //
        //Pointer is an integer that tells the code where in the array the frame they are calculating starts.
        //If you are calculating the fourth frame the pointer would be 6 which represents the start of the 4th frame.
        //
        //The partial array seen above is valid as this code will totals and displays the bowling score realtime 
        //
        //Returns a string representing the score for a frame of bowling
        //Sample, if someone bowled a 4 and a 5 in a frame the following would be returned - 9
        //*************************************************************************************************
        private static string CalculateFrameScore(string[] ballsArray, int pointer)
        {
            int FrameScore = -1;
            int ball1 = Convert.ToInt16(ballsArray[pointer]);

            //Use this to check for a spair
            int NextBall = -1;
            bool LastBall = false;
            if (ballsArray.Length != pointer + 1)
            {
                if (ballsArray[pointer + 1] != null)
                    NextBall = Convert.ToInt16(ballsArray[pointer + 1]);
            }
            else
            {
                LastBall = true;
            }

            if (pointer < 18)
            {

                if (ball1 == 10)
                {
                    //STRIKE logic
                    int strikeRollup1 = -1;
                    int strikeRollup2 = -1;

                    if (ballsArray[pointer + 2] != null)
                    {
                        strikeRollup1 = Convert.ToInt16(ballsArray[pointer + 2]);
                    }
                    if (ballsArray[pointer + 3] != null && ballsArray[pointer + 3] != "-1")
                    {
                        strikeRollup2 = Convert.ToInt16(ballsArray[pointer + 3]);
                    }
                    else if (ballsArray[pointer + 4] != null)
                    {
                        strikeRollup2 = Convert.ToInt16(ballsArray[pointer + 4]);
                    }

                    if (strikeRollup1 != -1 && strikeRollup2 != -1)
                    {
                        FrameScore = ball1 + strikeRollup1 + strikeRollup2;
                    }
                }
                else if (NextBall != -1 && NextBall + ball1 == 10)
                {
                    //Spair logic
                    int spairRollup = -1;
                    if (ballsArray[pointer + 2] != null)
                    {
                        spairRollup = Convert.ToInt16(ballsArray[pointer + 2]);
                    }
                    if (spairRollup != -1)
                    {
                        FrameScore = 10 + spairRollup;
                    }
                }
                else
                {
                    //Open logic
                    if (ballsArray[pointer + 1] != null)
                    {
                        int ball2 = Convert.ToInt16(ballsArray[pointer + 1]);
                        FrameScore = ball1 + ball2;
                    }
                    else
                        FrameScore = -1;
                }
            }
            else //10th frame Logic
            {
                int extraBall = -1;

                if (!LastBall && NextBall != -1 && NextBall + ball1 >= 10)
                {
                    //Extra Ball
                    if (ballsArray[20] != null)
                    {
                        extraBall = Convert.ToInt16(ballsArray[pointer + 2]);
                    }
                    if (extraBall != -1)
                    {
                        FrameScore = ball1 + NextBall + extraBall;
                    }
                    else if (ball1 + NextBall < 10)
                    {
                        FrameScore = ball1 + NextBall;
                    }
                }
                else {
                    FrameScore = ball1 + NextBall;
                }
            }

            return FrameScore.ToString();
        }

        public static bool StartOfFrame(int value)
        {
            return value % 2 == 0;
        }
    }
}