using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace BowlingScoreTest.Models
{
    public class FrameModel
    {
        public enum FrameStatusType
        {
            Incomplete = 0,
            Open = 1,
            Spare = 2,
            Strike = 3,
        }

        public int FrameNumber { get; private set; }
        public int Ball1 { get; private set; }
        public int Ball2 { get; private set; }
        public int Ball3 { get; private set; }
        public int FrameStatus { get; private set; }
        public int Score { get; set; }

        public FrameModel(int frameNumberInput, int ball1Input, int ball2Input, int ball3Input)
        {
            FrameNumber = frameNumberInput;
            Ball1 = ball1Input;
            Ball2 = ball2Input;
            Ball3 = ball3Input;

            if (Ball1 == 10)
                FrameStatus = (int)FrameModel.FrameStatusType.Strike;
            else if ((Ball1 + Ball2) == 10)
                FrameStatus = (int)FrameModel.FrameStatusType.Spare;
            else if ((Ball1 + Ball2) < 10)
                FrameStatus = (int)FrameModel.FrameStatusType.Open;

        }

        public static List<FrameModel> frameList = new List<FrameModel>();

        public static int CalculateScoreCard(FrameModel frame)
        {
            frameList.Add(frame);
            int RunningTotalScore = 0;

            foreach (FrameModel x in frameList)
            {
                if (x.FrameStatus == (int)FrameModel.FrameStatusType.Open)
                {
                    int pins = x.Ball1 + x.Ball2;
                    frame.Score = RunningTotalScore += x.Ball1 + x.Ball2;
                    return frame.Score;
                }
            }

            return -1;
        }
    }


}