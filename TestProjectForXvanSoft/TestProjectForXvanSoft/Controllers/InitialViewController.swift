//
//  InitialViewController.swift
//  TestProjectForXvanSoft
//
//  Created by Vitali Nabarouski on 2.09.22.
//

import UIKit
import AVFoundation

class InitialViewController: UIViewController {
    
    public var songsArray: [Song]?
    private var coverCollectionView: ArtworkCollectionView?
    private var playPauseButton: PlayerButton?
    private var previousButton: PlayerButton?
    private var nextButton: PlayerButton?
    private var timeSlider: TimeSlider?
    private var timeLeftLabel: TimeLabel?
    private var timeRightLabel: TimeLabel?
    private var songLabel: SongLabel!
    private var artistLabel: SongLabel!
    
    private var collectionConteinerView: UIView = UIView()
    private var labelsConteinerView: UIView = UIView()
    private var timeConteinerView: UIView = UIView()
    private var controllsConteinerView: UIView = UIView()
    
    private let audioPlayer: AVAudioPlayer = AVAudioPlayer()
    private var musicManager: MusicManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.prepareView()
        guard let timeSlider = timeSlider,
              let artistLabel = self.artistLabel,
              let songLabel = self.songLabel,
              let startTimeLabel = timeLeftLabel,
              let endTimeLabel = timeRightLabel,
              let playPauseButton = playPauseButton,
              let nextButton = nextButton,
              let previousButton = previousButton,
              let songs = self.songsArray,
              let collectionView = self.coverCollectionView
        else {
            return
        }
        
        self.musicManager = MusicManager(withTimeSlider: timeSlider,
                                         artistLabel: artistLabel,
                                         songLabel: songLabel,
                                         startTimeLabel: startTimeLabel,
                                         endTimeLabel: endTimeLabel,
                                         audioPlayer: self.audioPlayer,
                                         playButton: playPauseButton,
                                         nextButton: nextButton,
                                         previousButton: previousButton,
                                         songsArray: songs,
                                         collectionView: collectionView
                                         )
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func prepareView() {
        self.view.backgroundColor = UIColor(named: "backgroundColor")
        
        collectionConteinerView.backgroundColor = .red
        collectionConteinerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionConteinerView)
        
        NSLayoutConstraint.activate([
            collectionConteinerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            collectionConteinerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            collectionConteinerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 64),
            collectionConteinerView.bottomAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        addCollectionView()
        
        
        labelsConteinerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(labelsConteinerView)
        
        
        NSLayoutConstraint.activate([
            labelsConteinerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            labelsConteinerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            labelsConteinerView.topAnchor.constraint(equalTo: collectionConteinerView.bottomAnchor, constant: 72),
            labelsConteinerView.heightAnchor.constraint(equalToConstant: 48)
        ])
        
        addSongLabels()
        
        timeConteinerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(timeConteinerView)
        
        NSLayoutConstraint.activate([
            timeConteinerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            timeConteinerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            timeConteinerView.topAnchor.constraint(equalTo: labelsConteinerView.bottomAnchor, constant: 32),
            timeConteinerView.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        addTimeControls()
        
        controllsConteinerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(controllsConteinerView)
        
        NSLayoutConstraint.activate([
            controllsConteinerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            controllsConteinerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            controllsConteinerView.topAnchor.constraint(equalTo: timeConteinerView.bottomAnchor, constant: 32),
            controllsConteinerView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        addControllsButtons()
    }
    
    private func addSongLabels() {
        let labelsStack = UIStackView()
        labelsStack.distribution = .fillProportionally
        labelsStack.axis = .vertical
        labelsStack.spacing = 8
        
        songLabel = SongLabel(withType: .song)
        artistLabel = SongLabel(withType: .artist)
        labelsStack.addArrangedSubview(songLabel)
        labelsStack.addArrangedSubview(artistLabel)
        
        labelsStack.translatesAutoresizingMaskIntoConstraints = false
        self.labelsConteinerView.addSubview(labelsStack)
        
        NSLayoutConstraint.activate([
            labelsStack.leadingAnchor.constraint(equalTo: self.labelsConteinerView.leadingAnchor, constant: 16),
            labelsStack.trailingAnchor.constraint(equalTo: self.labelsConteinerView.trailingAnchor, constant: -16),
            labelsStack.topAnchor.constraint(equalTo: self.labelsConteinerView.topAnchor),
            labelsStack.bottomAnchor.constraint(equalTo: self.labelsConteinerView.bottomAnchor)
        ])
    }
    
    private func addTimeControls() {
        self.timeLeftLabel = TimeLabel(withTypeOfLabel: .start)
        self.timeLeftLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.timeRightLabel = TimeLabel(withTypeOfLabel: .end)
        self.timeRightLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.timeSlider = TimeSlider(withPlayer: self.audioPlayer)
        self.timeSlider?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let timeLeftLabel = timeLeftLabel,
              let timeRightLabel = timeRightLabel,
              let timeSlider = timeSlider
        else {
            return
        }
        self.timeConteinerView.addSubview(timeLeftLabel)
        self.timeConteinerView.addSubview(timeRightLabel)
        self.timeConteinerView.addSubview(timeSlider)
        
        NSLayoutConstraint.activate([
            timeSlider.leadingAnchor.constraint(equalTo: self.timeConteinerView.leadingAnchor, constant: 16),
            timeSlider.trailingAnchor.constraint(equalTo: self.timeConteinerView.trailingAnchor, constant: -16),
            timeSlider.topAnchor.constraint(equalTo: self.timeConteinerView.topAnchor),
            timeSlider.heightAnchor.constraint(equalToConstant: self.timeConteinerView.bounds.size.height / 2)
        ])
        
        NSLayoutConstraint.activate([
            timeLeftLabel.leadingAnchor.constraint(equalTo: timeSlider.leadingAnchor),
            timeLeftLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 5),
            timeLeftLabel.bottomAnchor.constraint(equalTo: timeConteinerView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            timeRightLabel.trailingAnchor.constraint(equalTo: timeSlider.trailingAnchor),
            timeRightLabel.topAnchor.constraint(equalTo: timeSlider.bottomAnchor, constant: 5),
            timeRightLabel.bottomAnchor.constraint(equalTo: timeConteinerView.bottomAnchor)
        ])
    }
    
    private func addControllsButtons() {
        
        self.playPauseButton = PlayerButton(withTypeOfButton: .playButton)
        self.playPauseButton?.translatesAutoresizingMaskIntoConstraints = false
        guard let playPauseButton = playPauseButton else {
            return
        }
        
        controllsConteinerView.addSubview(playPauseButton)
        
        NSLayoutConstraint.activate([
            playPauseButton.centerXAnchor.constraint(equalTo: controllsConteinerView.centerXAnchor),
            playPauseButton.topAnchor.constraint(equalTo: controllsConteinerView.topAnchor),
            playPauseButton.bottomAnchor.constraint(equalTo: controllsConteinerView.bottomAnchor),
            playPauseButton.widthAnchor.constraint(equalTo: self.playPauseButton!.heightAnchor)
        ])
        
        self.previousButton = PlayerButton(withTypeOfButton: .previousButton)
        self.previousButton?.translatesAutoresizingMaskIntoConstraints = false
        guard let previousButton = previousButton else {
            return
        }
        
        controllsConteinerView.addSubview(previousButton)
        
        NSLayoutConstraint.activate([
            previousButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20),
            previousButton.widthAnchor.constraint(equalToConstant: 26),
            previousButton.heightAnchor.constraint(equalTo: previousButton.widthAnchor)
        ])
        
        self.nextButton = PlayerButton(withTypeOfButton: .nextButton)
        self.nextButton?.translatesAutoresizingMaskIntoConstraints = false
        guard let nextButton = nextButton else {
            return
        }
        
        controllsConteinerView.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            nextButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20),
            nextButton.widthAnchor.constraint(equalToConstant: 26),
            nextButton.heightAnchor.constraint(equalTo: nextButton.widthAnchor)
        ])
    }
    
    private func addCollectionView() {
        let song1 = Song().getSong(fromBundleID: "01. Groundhog Day")
        let song2 = Song().getSong(fromBundleID: "02. Road (Feat. Arctic Lake)")
        let song3 = Song().getSong(fromBundleID: "03. Just")
        let song4 = Song().getSong(fromBundleID: "04. Brightest Lights (Feat. POLICA)")
        let song5 = Song().getSong(fromBundleID: "05. Sunday Song")
        self.songsArray = Array()
        self.songsArray?.append(song1)
        self.songsArray?.append(song2)
        self.songsArray?.append(song3)
        self.songsArray?.append(song4)
        self.songsArray?.append(song5)
        guard let songsArray = songsArray else {
            return
        }
        
        self.coverCollectionView = ArtworkCollectionView(withSongs: songsArray)
        guard let coverCollectionView = coverCollectionView else {
            return
        }
        
        coverCollectionView.backgroundColor = self.view.backgroundColor
        self.collectionConteinerView.addSubview(coverCollectionView)
        coverCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            coverCollectionView.leadingAnchor.constraint(equalTo: collectionConteinerView.leadingAnchor),
            coverCollectionView.trailingAnchor.constraint(equalTo: collectionConteinerView.trailingAnchor),
            coverCollectionView.topAnchor.constraint(equalTo: collectionConteinerView.topAnchor),
            coverCollectionView.bottomAnchor.constraint(equalTo: collectionConteinerView.bottomAnchor)
        ])
        
    }
}


