# frozen_string_literal: true

# Classe modelo do Usuario
class User < ApplicationRecord
  has_one :coordinator, dependent: :destroy
  has_one :administrative_assistant, dependent: :destroy
  has_one :deg, dependent: :destroy
  accepts_nested_attributes_for :coordinator, reject_if: :all_blank
  accepts_nested_attributes_for :administrative_assistant
  accepts_nested_attributes_for :deg, reject_if: :all_blank

  has_many :allocations
  has_many :allocationExtensions
  has_many :school_rooms
  has_many :api_users, dependent: :destroy

  has_secure_password

  mount_uploader :image, AvatarUploader
  # Nome
  CHARS_MIN_FOR_THE_NAME_EXCEPTION = 'O Nome deve ter no mínimo 7 caracteres'.freeze
  CHARS_MAX_FOR_THE_NAME_EXCEPTION = 'Nome deve ter no máximo 100 caracters'.freeze

  validates_length_of :name,
                      within: 7..100,
                      too_short: CHARS_MIN_FOR_THE_NAME_EXCEPTION,
                      too_long: CHARS_MAX_FOR_THE_NAME_EXCEPTION

  # Email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@unb.br\z/i
  EMAIL_EXISTS = 'E-mail já cadastrado no sistema'.freeze
  NULL_EMAIL = 'E-mail não pode ser vazio'.freeze
  INVALID_EMAIL = 'Insira um E-mail válido'.freeze

  validates :email, presence: { message: NULL_EMAIL },
                    length: { maximum: 50 }, uniqueness: { message: EMAIL_EXISTS },
                    format: { with: VALID_EMAIL_REGEX, message: INVALID_EMAIL }

  # Senha
  PASSWORD = 'Senha deve possuir um mínimo de 6 e um máximo de 20 caracteres'.freeze

  validates :password, length: { minimum: 6, maximum: 20,
                                 message: PASSWORD },
                       confirmation: true

  # Cpf
  VALID_CPF_REGEX = /\A[0-9]{3}?[0-9]{3}?[0-9]{3}?[0-9]{2}\z/i
  CPF_EXISTS = 'CPF já cadastrado no sistema'.freeze
  NULL_CPF = 'CPF não pode ser vazio'.freeze
  INVALID_CPF = 'Insira um CPF válido'.freeze

  validates :cpf, presence: { message: NULL_CPF },
                  uniqueness: { message: CPF_EXISTS },
                  format: { with: VALID_CPF_REGEX, message: INVALID_CPF }

  # Matricula
  VALID_REGISTRATION_REGEX = /\A[0-9]{7}\z/i
  REGISTRATION_EXISTS = 'Registro UnB já cadastrado no sistema'.freeze
  NULL_REGISTRATION = 'Registro UnB não pode ser vazio'.freeze
  INVALID_REGISTRATION = 'Insira um Registro UnB válido'.freeze

  validates :registration, presence: { message: NULL_REGISTRATION },
                           format: { with: VALID_REGISTRATION_REGEX,
                                     message: INVALID_REGISTRATION },
                           uniqueness: { message: REGISTRATION_EXISTS }
end
