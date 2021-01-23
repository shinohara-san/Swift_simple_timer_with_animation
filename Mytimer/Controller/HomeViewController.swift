//
//  HomeViewController.swift
//  Mytimer
//
//  Created by Yuki Shinohara on 2021/01/22.

///  アニメーション動き出したらgotosettingさせない

import UIKit

class HomeViewController: UIViewController, CAAnimationDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var remainSecLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    let foreProgressLayer = CAShapeLayer()
    let backProgressLayer = CAShapeLayer()
    let animatation = CABasicAnimation(keyPath: "strokeEnd")
    var isAnimationStarted = false
    
    var timer = Timer()
    var isTimerStarted = false
    var time: Int = 90
    
    override func viewDidLoad() {
        super.viewDidLoad()
        drawBackLayer()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        time = UserDefaults.standard.integer(forKey: "savedTime")
        remainSecLabel.text = formatTime()
        let timerTitle = UserDefaults.standard.string(forKey: "savedTitle")
        titleLabel.text = timerTitle
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        cancelButton.isEnabled = true
        cancelButton.alpha = 1.0 //最初は少し暗いけどスタート押したら通常の濃さで表示される
        
        if !isTimerStarted{
            drawForeLayer() //アニメーション。前の赤い方の円を描く
            startResumedAnimation() //アニメーションの処理
            startTimer()
            isTimerStarted = true
            startButton.setTitle("Pause", for: .normal)
            startButton.setTitleColor(UIColor.orange, for: .normal)
        } else {
            pauseAnimation() //Animation
            timer.invalidate()
            isTimerStarted = false
            startButton.setTitle("Resume", for: .normal)
            startButton.setTitleColor(UIColor.green, for: .normal)
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        stopAnimation() //アニメーションを止める
        cancelButton.isEnabled = false
        cancelButton.alpha = 0.5
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.green, for: .normal)
        timer.invalidate()
        isTimerStarted = false
        time = UserDefaults.standard.integer(forKey: "savedTime")
        remainSecLabel.text = formatTime()
    }
    
    func drawBackLayer(){
        //円を描いている
        backProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 120,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        backProgressLayer.strokeColor = UIColor.white.cgColor //円の縁の色
        backProgressLayer.lineWidth = 15 //円の縁の太さ
        backProgressLayer.fillColor = UIColor.clear.cgColor //円の内側の色
        view.layer.addSublayer(backProgressLayer)
    }
    
    //前の、赤の、動く方の円
    func drawForeLayer(){
        foreProgressLayer.path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: view.frame.midY),
                                              radius: 120,
                                              startAngle: -90.degreesToRadians,
                                              endAngle: 270.degreesToRadians,
                                              clockwise: true).cgPath
        foreProgressLayer.strokeColor = UIColor.red.cgColor
        foreProgressLayer.fillColor = UIColor.clear.cgColor
        foreProgressLayer.lineWidth = 15
        view.layer.addSublayer(foreProgressLayer)
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        if time < 1 { //0になったら
            cancelButton.isEnabled = false
            cancelButton.alpha = 0.5
            startButton.setTitle("Start", for: .normal)
            startButton.setTitleColor(.green, for: .normal)
            timer.invalidate()
            time = UserDefaults.standard.integer(forKey: "savedTime")
            isTimerStarted = false
            remainSecLabel.text = formatTime()
        } else {
            time -= 1
            remainSecLabel.text = formatTime()
        }
    }
    
    func formatTime()->String{
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func startResumedAnimation(){
        //        Startを押したときにタイマーが走っていない時に発動→animationが始まっていたらresumeでまだだったらstartが発火
        //        ※timerStartedとanimeStartedをごっちゃにしない
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAnimation() //Pauseボタンを押すと再びアニメーションがスタート
        }
    }
    
    func startAnimation(){
        resetAnimation() //内部的に一旦リセットしてanimationをスタートさせる
        foreProgressLayer.strokeEnd = 0.0 //0からスタート
        animatation.keyPath = "strokeEnd"
        animatation.fromValue = 0
        animatation.toValue = 1 //0から1
        animatation.duration = CFTimeInterval(UserDefaults.standard.integer(forKey: "savedTime"))
        animatation.delegate = self
        animatation.isRemovedOnCompletion = false
        animatation.isAdditive = true
        animatation.fillMode = CAMediaTimingFillMode.forwards
        foreProgressLayer.add(animatation, forKey: "strokeEnd")
        isAnimationStarted = true
    }
    
    func resetAnimation(){
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0 //?
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        isAnimationStarted = false
    }
    
    func pauseAnimation(){ //タイマー走っている&&start(pause)が押されて発動
        let pausedTime = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) //この値が2行下で代入後、アニメーションが再スタートした際に使われる
        foreProgressLayer.speed = 0.0 //0でないと赤い部分がなくなって再スタートでまた最初から赤がスタートする
        foreProgressLayer.timeOffset = pausedTime
    }
    
    func resumeAnimation(){ //Startを押した時にtimerは走っていない&&アニメはスタートしてる
        let pausedTime = foreProgressLayer.timeOffset // pauseAnimationでpausedTimeを代入したforeProgressLayer.timeOffset???
        foreProgressLayer.speed = 1.0 //2.0だと再スタートした際に赤アニメーションが最初からになる
        foreProgressLayer.timeOffset = 0.0 //一旦リセットして次で再設定?
        foreProgressLayer.beginTime = 0.0//一旦リセットして次で再設定?
        let timeSincePaused = foreProgressLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        foreProgressLayer.beginTime = timeSincePaused //停止したところからスタート?
    }
    
    func stopAnimation(){  //cancelボタンを押した時とanimationDidStopのとき
        foreProgressLayer.speed = 1.0
        foreProgressLayer.timeOffset = 0.0 //?
        foreProgressLayer.beginTime = 0.0
        foreProgressLayer.strokeEnd = 0.0
        foreProgressLayer.removeAllAnimations()
        isAnimationStarted = false
    }
    
    //これを追加したらタイマー残り0の時に赤い部分が消える?? startAnimationにdelegate追加
    //
    internal func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        stopAnimation()
    }
}
