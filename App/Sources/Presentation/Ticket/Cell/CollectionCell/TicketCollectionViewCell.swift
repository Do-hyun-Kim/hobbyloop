//
//  TicketCollectionViewCell.swift
//  Hobbyloop
//
//  Created by 김진우 on 2023/06/04.
//

import UIKit

import RxSwift
import HPCommonUI

class TicketCollectionViewCell: UICollectionViewCell {
    private var imageView: UIImageView = UIImageView().then {
        $0.image = UIImage(named: "TicketTestImage")
    }
    
    private var storeStackView: UIStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
    }
    
    private var titleStackView: UIStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .vertical
        $0.alignment = .leading
    }
    
    private var titleLabel: UILabel = UILabel().then {
        $0.font = HPCommonUIFontFamily.Pretendard.semiBold.font(size: 20)
    }
    
    private var descriptionLabel: UILabel = UILabel().then {
        $0.font = HPCommonUIFontFamily.Pretendard.regular.font(size: 12)
    }
    
    private var archiveButton: UIButton = UIButton().then {
        $0.setImage(HPCommonUIAsset.archiveOutlined.image.withRenderingMode(.alwaysOriginal), for: .normal)
        $0.setImage(HPCommonUIAsset.archiveFilled.image.withRenderingMode(.alwaysOriginal), for: .selected)
    }
    
    private var rightStackView: UIStackView = UIStackView().then {
        $0.spacing = 9
        $0.axis = .vertical
        $0.alignment = .trailing
    }
    
    private var starStackView: UIStackView = UIStackView().then {
        $0.spacing = 5
        $0.axis = .horizontal
    }
    
    private var starImageView: UIImageView = UIImageView().then {
        $0.tintColor = UIColor(red: 255/255, green: 194/255, blue: 0, alpha: 1)
    }
    
    private var starLabel: UILabel = UILabel().then {
        $0.font = HPCommonUIFontFamily.Pretendard.regular.font(size: 12)
    }
    
    public lazy var tableView: UITableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(TicketTableViewHeaderCell.self, forHeaderFooterViewReuseIdentifier: "HeaderCell")
        $0.register(TicketTableViewCell.self, forCellReuseIdentifier: "BodyCell")
        $0.separatorInset = .zero
        $0.separatorStyle = .singleLine
        $0.separatorInsetReference = .fromCellEdges
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
    }
    
    private var data: [Int]?
    public let cellSelect: PublishSubject<Int> = PublishSubject<Int>()
    private let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initLayout() {
        backgroundColor = .white
        
        [imageView, storeStackView, tableView].forEach {
            addSubview($0)
        }
        
        [titleStackView, rightStackView].forEach {
            storeStackView.addArrangedSubview($0)
        }
        
        [archiveButton, starStackView].forEach {
            rightStackView.addArrangedSubview($0)
        }
        
        [titleLabel, descriptionLabel].forEach {
            titleStackView.addArrangedSubview($0)
        }
        
        [starImageView, starLabel].forEach {
            starStackView.addArrangedSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(262)
        }
        
        storeStackView.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(14)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(47)
        }
        
        starImageView.snp.makeConstraints {
            $0.width.height.equalTo(13)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(storeStackView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    public func configure(_ data: [Int]? = nil) {
        self.data = data
        imageView.image = UIImage(named: "TicketTestImage")?.withRenderingMode(.alwaysOriginal)
        titleLabel.text = "필라피티 스튜디오"
        descriptionLabel.text = "서울 강남구 압구정로50길 8 2층"
        starLabel.text = "4.8"
        starImageView.image = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
    }
}

extension TicketCollectionViewCell: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BodyCell", for: indexPath) as? TicketTableViewCell else { return UITableViewCell() }
        cell.configure(data!)
        cell.layoutMargins = .zero
        cell.preservesSuperviewLayoutMargins = false
        cell.cellSelect
            .bind(to: cellSelect)
            .disposed(by: disposeBag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 69
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("클릭")
    }
}

extension TicketCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "HeaderCell") as? TicketTableViewHeaderCell else { return UIView() }
        header.configure(data!.count)
        return header
    }
}
