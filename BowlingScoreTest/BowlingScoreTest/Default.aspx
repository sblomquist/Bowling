<%@ Page Title="Home Page" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BowlingScoreTest._Default" %>
<%--<%@ Page Title="Home Page" Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="BowlingScoreTest._Default" %>--%>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">

<script type="text/javascript">
        var CurrentFrame = 1;
        var CurrentFrameBall = 1;
        var pinsArray = new Array(21);
        var pinsArrayPointer = 0;

        function OnSuccess(result) {
            //alert("success");
            var scoreArray = result.split(',');
            var score;

            //Update the Frame Scores with what was returned from the WebMethod
            for (i = 0; i < scoreArray.length; i++) {
                score = scoreArray[i];

                if (score >= 0) {
                    if (i + 1 < 11) {
                        var ScoreName = "Frame" + (i + 1) + "Score";
                        $(ScoreName).prop('disabled', false);
                        document.getElementById(ScoreName).value = score;
                        $(ScoreName).prop('disabled', true);
                    }
                }
                else {
                    break;
                }
            }
        }

        function onError(result) {
            alert('Something wrong.');
            alert(result);
        }
        
        //On Click of a number button this runs
        function setScoreCardFrame(obj) {
            var val = obj.value;
            var FrameName = "Frame" + CurrentFrame;
            console.log(val);
            $(FrameName).prop('disabled', false);
            //UI Rules for everything outside of the tenth frame
            if (pinsArrayPointer < 18) {
                //If Strike
                if (val == 10 && CurrentFrameBall == 1) {
                    //alert("Strike");
                    document.getElementById(FrameName).value = val;
                    pinsArray[pinsArrayPointer] = val;
                    pinsArrayPointer++;
                    pinsArray[pinsArrayPointer] = -1;
                    pinsArrayPointer++;

                    //Update form with most recent data
                    PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);

                    CurrentFrame++;
                }
                //No Strike ball one
                else if (CurrentFrameBall == 1) {
                    //alert("Ball one");
                    document.getElementById(FrameName).value = val + ',';
                    DisableButtons(val);
                    pinsArray[pinsArrayPointer] = val;
                    pinsArrayPointer++;

                    //Update form with most recent data
                    PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);

                    CurrentFrameBall++;
                }
                //Ball two
                else {
                    //alert("Ball two");

                    document.getElementById(FrameName).value += val;
                    var pins = document.getElementById(FrameName).value;
                    pinsArray[pinsArrayPointer] = val;
                    pinsArrayPointer++;

                    //Update form with most recent data
                    PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);

                    CurrentFrameBall = 1;
                    CurrentFrame++;
                    EnableButtons();
                }
            }
            else{
                //This is special code to handle the UI for the tenth frame and the extra ball
                    //If ball 19
                    if (pinsArrayPointer == 18) {
                        document.getElementById(FrameName).value = val + ',';
                        pinsArray[pinsArrayPointer] = val;
                        pinsArrayPointer++;

                        //Update form with most recent data
                        PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);

                        if (val != 10) {
                            DisableButtons(val);
                        }
                    }
                    //if ball 20 AKA 10 Frame
                    else if (pinsArrayPointer == 19) {
                        document.getElementById(FrameName).value += val;
                        pinsArray[pinsArrayPointer] = val;
                        pinsArrayPointer++;

                        //Update form with most recent data
                        PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);
                        
                        var Ball19 = pinsArray[18];
                        var Ball20 = pinsArray[19];
                        var SumOfLastTwoBalls = +Ball19 + +Ball20;

                        if (pinsArrayPointer == 20 && SumOfLastTwoBalls >= 10) 
                        { 
                            //Check to see if we need to have an Extra Ball in the 10th
                            //If so, enable the UI
                            if (SumOfLastTwoBalls == 10 || SumOfLastTwoBalls == 20) {
                                EnableButtons();
                            }
                            else
                            {
                                DisableButtons(val);
                            }
                            
                        }
                        else {
                            //Disable All Buttons we are done.
                            DisableButtons(11);
                            alert("Game Over - Refresh to Play Again.");
                        }
                    }
                    //if Extra ball 21
                    else if (pinsArrayPointer == 20) {
                        //alert("Ball 21");
                        document.getElementById(FrameName).value += "," + val;
                        pinsArray[pinsArrayPointer] = val;
                        pinsArrayPointer++;

                        PageMethods.FrameUpdate(pinsArray, OnSuccess, onError);

                        //Disable All Buttons we are done.
                        DisableButtons(11);
                        alert("Game Over - Refresh to Play Again.");

                    }
                }
                $(FrameName).prop('disabled', true);
            }



        function DisableButtons(n) {
            var buttonNumber = 10;
            var ButtonName = "btn" + n;
            for (i = 1; i <= n; i++) {
                ButtonName = "btn" + buttonNumber;
                document.getElementById(ButtonName).disabled = true;
                                               
                buttonNumber--;
            }
        }

        function EnableButtons() {
            for (i = 0; i <= 10; i++) {
                ButtonName = "btn" + i;
                document.getElementById(ButtonName).disabled = false;
            }
        }

</script>

<br />

<div class="container">
    <div class="row">
        <div class="col-sm-1">
            <label>Frame</label>
        </div>
        <div class="col-sm-1">
            <label>1</label>
        </div>
        <div class="col-sm-1">
            <label>2</label>
        </div>
        <div class="col-sm-1">
            <label>3</label>
        </div>
        <div class="col-sm-1">
            <label>4</label>
        </div>
        <div class="col-sm-1">
            <label>5</label>
        </div>
        <div class="col-sm-1">
            <label>6</label>
        </div>
        <div class="col-sm-1">
            <label>7</label>
        </div>
        <div class="col-sm-1">
            <label>8</label>
        </div>
        <div class="col-sm-1">
            <label>9</label>
        </div>
        <div class="col-sm-2">
            <label>10</label>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-1">
            John
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame1" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame2" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame3" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame4" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame5" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame6" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame7" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame8" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame9" disabled>
        </div>
        <div class="col-sm-2">
            <input type="text" class="form-control disabled" id="Frame10" disabled>
        </div>
    </div>
    <br />
    <div class="row">
        <div class="col-sm-1">
            <label>Score</label>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame1Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame2Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame3Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame4Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame5Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame6Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame7Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame8Score" disabled>
        </div>
        <div class="col-sm-1">
            <input type="text" class="form-control disabled" id="Frame9Score" disabled>
        </div>
        <div class="col-sm-2">
            <input type="text" class="form-control disabled" id="Frame10Score" disabled>
        </div>
    </div>
 </div>

    <div class="row">
        <div class="col-md-4 text-center">
            <h2>Enter Score</h2>
            <div class="btn-group" style="text-align:center" role="group" aria-label="...">
                <button id="btn10" type="button" class="btn btn-default" value="10" onclick="setScoreCardFrame(this)">10</button>
            </div><br />
            <div class="btn-group" role="group" aria-label="...">
                <button id="btn9" type="button" class="btn btn-default" value="9" onclick="setScoreCardFrame(this)">9</button>
                <button id="btn8" type="button" class="btn btn-default" value="8" onclick="setScoreCardFrame(this)">8</button>
                <button id="btn7" type="button" class="btn btn-default" value="7" onclick="setScoreCardFrame(this)">7</button>
            </div><br />
            <div class="btn-group" style="text-align:center" role="group" aria-label="...">
                <button id="btn6" type="button" class="btn btn-default" value="6" onclick="setScoreCardFrame(this)">6</button>
                <button id="btn5" type="button" class="btn btn-default" value="5" onclick="setScoreCardFrame(this)">5</button>
                <button id="btn4" type="button" class="btn btn-default" value="4" onclick="setScoreCardFrame(this)">4</button>
            </div><br />
            <div class="btn-group" style="text-align:center" role="group" aria-label="...">
                <button id="btn3" type="button" class="btn btn-default" value="3" onclick="setScoreCardFrame(this)">3</button>
                <button id="btn2" type="button" class="btn btn-default" value="2" onclick="setScoreCardFrame(this)">2</button>
                <button id="btn1" type="button" class="btn btn-default" value="1" onclick="setScoreCardFrame(this)">1</button>
            </div><br />
            <div class="btn-group" style="text-align:center" role="group" aria-label="...">
                <button id="btn0" type="button" class="btn btn-default" value="0" onclick="setScoreCardFrame(this)">0</button>
            </div><br />
        </div>
    </div>

</asp:Content>
