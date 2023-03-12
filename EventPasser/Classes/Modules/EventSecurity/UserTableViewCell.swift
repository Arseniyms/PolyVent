//
//  UserTableViewCell.swift
//  EventPasser
//
//  Created by Arseniy Matus on 08.12.2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    private let fullName = UILabel()
    private let age = UILabel()

    private lazy var isInsideImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 1

        return stackView
    }()

    func setCell(with user: UserEntity, isUserInside: Bool) {
        self.fullName.text = "Имя - \(user.wrappedFullName)"
        self.age.text = "Возраст - \(user.wrappedAge)"
        isInsideImageView.image = UIImage(systemName: "checkmark.seal.fill")?.withRenderingMode(.alwaysTemplate)
        self.isInsideImageView.tintColor = isUserInside ? .systemGreen : .systemRed
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .customBackgroundColor

        fullName.font = .preferredFont(forTextStyle: .callout)
        age.font = .preferredFont(forTextStyle: .caption1)

        stackView.addArrangedSubview(fullName)
        stackView.addArrangedSubview(age)

        contentView.addSubview(isInsideImageView)
        contentView.addSubview(stackView)
        isInsideImageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            isInsideImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isInsideImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: isInsideImageView.leadingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
