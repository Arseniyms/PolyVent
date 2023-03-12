//
//  EventTableViewCell.swift
//  EventPasser
//
//  Created by Arseniy Matus on 19.11.2022.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    private let name = UILabel()
    private let address = UILabel()
    private let timeStart = UILabel()
    private let guestsCount = UILabel()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 3

        return stackView
    }()

    private lazy var isSetImageView: UIImageView = {
        let imageView = UIImageView()

        return imageView
    }()

    func setCell(with event: EventEntity, isSet: Bool = false) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        self.name.text = event.wrappedTitle
        self.address.text = event.address
        self.timeStart.text = dateFormatter.string(from: event.wrappedTimeStart)
        self.guestsCount.text = "\(event.wrappedCurrentAmountOfTickets)/\(event.wrappedMaxCount)"

        var image: UIImage?
        image = UIImage(named: "ticket.fill")?.withRenderingMode(.alwaysTemplate)
        isSetImageView.image = image
        let largeConfig = UIImage.SymbolConfiguration(textStyle: .title2)
        image = image?.withConfiguration(largeConfig)

        if isSet {
            isSetImageView.tintColor = .systemGreen
        } else {
            isSetImageView.tintColor = .systemGray
        }
    }

    var backView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(backView)
        backView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            backView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            backView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            backView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
        ])

        backgroundColor = .clear
        backView.layer.masksToBounds = false
        backView.layer.shadowOpacity = 0.5
        backView.layer.shadowRadius = 3
        backView.layer.shadowOffset = CGSize(width: 0, height: 0)
        backView.layer.shadowColor = UIColor.buttonColor.cgColor

        backView.backgroundColor = .customBackgroundColor
        backView.layer.cornerRadius = 8

        stackView.translatesAutoresizingMaskIntoConstraints = false
        isSetImageView.translatesAutoresizingMaskIntoConstraints = false
        backView.addSubview(stackView)
        backView.addSubview(isSetImageView)

        name.font = .boldSystemFont(ofSize: 18)
        address.font = .systemFont(ofSize: 15)
        timeStart.font = .systemFont(ofSize: 15)
        guestsCount.font = .systemFont(ofSize: 15)
        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(address)
        stackView.addArrangedSubview(timeStart)
        stackView.addArrangedSubview(guestsCount)

        NSLayoutConstraint.activate([
            isSetImageView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            isSetImageView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: -20),

            stackView.centerYAnchor.constraint(equalTo: backView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 30),
            stackView.trailingAnchor.constraint(equalTo: isSetImageView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: -5),
        ])

        selectionStyle = .none
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        UIView.animate(withDuration: 0.5, delay: 0) {
            if highlighted {
                self.backView.backgroundColor = .buttonColor.withAlphaComponent(0.4)
                self.backView.transform = CGAffineTransform.identity.scaledBy(x: 0.90, y: 0.90)
            } else {
                self.backView.backgroundColor = .customBackgroundColor
                self.backView.transform = .identity
            }
        }
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
