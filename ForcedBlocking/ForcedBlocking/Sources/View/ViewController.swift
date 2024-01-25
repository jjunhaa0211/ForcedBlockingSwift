//
//  ViewController.swift
//  ForcedBlocking
//
//  Created by 박준하 on 1/22/24.
//

import UIKit
import FamilyControls
import SwiftUI
import Then
import SnapKit

final class ViewController: UIViewController {

    // MARK: - Properties
    var hostingController: UIHostingController<SwiftUIView>?
    
    private let center = AuthorizationCenter.shared
    private let blocker = Blocker()

    private lazy var contentView: UIHostingController<some View> = {
        let model = BlockingModel.shared
        let hostingController = UIHostingController(
            rootView: SwiftUIView()
                .environmentObject(model)
        )
        return hostingController
    }()

    private let blockButton = UIButton(type: .system).then {
        $0.setTitle("차단하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .red
        $0.layer.cornerRadius = 8
    }
    
    private let releaseButton = UIButton(type: .system).then {
        $0.setTitle("해제하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .blue
        $0.layer.cornerRadius = 8
    }
    
    private let buttonStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
        $0.distribution = .fillEqually
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestAuthorization()
    }
}

extension ViewController {
    private func setup() {
        addView()
        layout()
        addTargets()
    }

    private func addTargets() {
        blockButton.addTarget(self, action: #selector(tappedBlockButton), for: .touchUpInside)
        releaseButton.addTarget(self, action: #selector(tappedReleaseButton), for: .touchUpInside)
    }

    private func addView() {
        buttonStackView.addArrangedSubview(blockButton)
        buttonStackView.addArrangedSubview(releaseButton)
        view.addSubview(buttonStackView)
        addChild(contentView)
        view.addSubview(contentView.view)
    }

    private func layout() {
        contentView.view.snp.makeConstraints {
            $0.top.equalTo(view.snp.top)
            $0.leading.equalTo(view.snp.leading)
            $0.trailing.equalTo(view.snp.trailing)
            $0.bottom.equalTo(blockButton.snp.top)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(view.snp.bottom).offset(-160)
            $0.leading.equalTo(view.snp.leading).offset(60)
            $0.trailing.equalTo(view.snp.trailing).offset(-60)
            $0.bottom.equalTo(view.snp.bottom).offset(-60)
        }
    }
}

extension ViewController {
    @objc private func tappedBlockButton() {
        blocker.block { result in
            switch result {
            case .success():
                print("차단 성공")
            case .failure(let error):
                print("차단 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc private func tappedReleaseButton() {
        print("차단 해제")
        blocker.unblockAllApps()
    }
    
    private func requestAuthorization() {
        Task {
            do {
                try await center.requestAuthorization(for: .individual)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
